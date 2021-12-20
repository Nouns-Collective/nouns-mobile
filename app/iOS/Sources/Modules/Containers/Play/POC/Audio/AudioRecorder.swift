//
//  AudioRecorder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-04.
//

import Foundation
import AVFoundation
import SwiftUI

enum AudioRecordingError: Error {
  case permissionDenied
  case permission(error: Error)
  case recording(error: Error)
  case session(error: Error)
}

// swiftlint:disable all
class AudioRecorder: NSObject, ObservableObject {
  private let recordingSession: AVAudioSession = AVAudioSession.sharedInstance()
  private var engine: AVAudioEngine!
  private var mixerNode: AVAudioMixerNode!
  
  private let player = AVAudioPlayerNode()
  private let timeEffect = AVAudioUnitTimePitch()

  var isPlaying: Bool = false
  var needsFileScheduled: Bool = true
  
  private var silenceTimer: Timer = Timer()
  static let SilenceThreshold: TimeInterval = 1.5
  
  enum Speed: Float, Identifiable {
    var id: RawValue { rawValue }
    
    static let allValues: [Speed] = [.verySlow,
                                     .slow,
                                     .regular,
                                     .fast,
                                     .veryFast]
    case verySlow = 0.25
    case slow = 0.5
    case regular = 1
    case fast = 1.5
    case veryFast = 2
    
    var string: String {
      let formatter = NumberFormatter()
      formatter.minimumIntegerDigits = 1
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 2
      return formatter.string(from: NSNumber(value: self.rawValue)) ?? String(self.rawValue)
    }
  }
  
  enum Pitch: Float, Identifiable {
    var id: RawValue { rawValue }
    
    static let allValues: [Pitch] = [.veryLow,
                                     .low,
                                     .regular,
                                     .high,
                                     .veryHigh]
    case veryLow = -0.25
    case low = -0.5
    case regular = 0
    case high = 0.5
    case veryHigh = 1
    
    var string: String {
      let formatter = NumberFormatter()
      formatter.minimumIntegerDigits = 1
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 2
      return formatter.string(from: NSNumber(value: self.rawValue)) ?? String(self.rawValue)
    }
  }
  
  enum RecordingState {
    case recording
    case silence
    case stopped
    case playback
  }
  
  var state: RecordingState = .stopped {
    didSet {
      if oldValue == .recording && state == .stopped {
        playBack()
      } else if oldValue == .playback && state == .stopped {
        startRecording()
      }
    }
  }
  
  private func writeFileURL(format: AVAudioFormat) throws -> AVAudioFile {
    /// AVAudioFile uses the Core Audio Format (CAF) to write to disk.
    /// So we're using the caf file extension.
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
      return try AVAudioFile(forWriting: documentURL.appendingPathComponent("latest.caf"), settings: format.settings)
    } catch {
      throw AudioRecordingError.recording(error: error)
    }
  }
  
  private func readFileURL() throws -> AVAudioFile {
    /// AVAudioFile uses the Core Audio Format (CAF) to write to disk.
    /// So we're using the caf file extension.
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
      return try AVAudioFile(forReading: documentURL.appendingPathComponent("latest.caf"))
    } catch {
      throw AudioRecordingError.recording(error: error)
    }
  }
  
  @Published var url: URL? {
    willSet {
      objectWillChange.send()
    }
  }
  
  override init() {
    super.init()
    
    setupSession()
    setupEngine()
    
    self.startTimer()
  }
  
  deinit {
    stopRecording()
  }
  
  func requestPermission(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
    recordingSession.requestRecordPermission() { allowed in
      DispatchQueue.main.async {
        if allowed {
          completion(true, nil)
        } else {
          completion(false, AudioRecordingError.permissionDenied)
        }
      }
    }
  }
  
  private func setupSession() {
    do {
      try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
      try recordingSession.setActive(true)
    } catch {
      print(AudioRecordingError.session(error: error))
    }
  }
  
  private func setupEngine() {
    engine = AVAudioEngine()
    mixerNode = AVAudioMixerNode()
    
    // Set volume to 0 to avoid audio feedback while recording.
    mixerNode.volume = 0
    
    engine.attach(mixerNode)
    
    makeConnections()
    
    engine.prepare()
  }
  
  /// Sets up all required input nodes as well as the mixer
  /// The mixer takes inputs from multiple sources and converts it to a single output
  /// In this case, we only have one input
  private func makeConnections() {
    // Input (recording) related
    let inputFormat = engine.inputNode.outputFormat(forBus: 0)
    engine.connect(engine.inputNode, to: mixerNode, format: inputFormat)
    
    let mainMixerNode = engine.mainMixerNode
    let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
    engine.connect(mixerNode, to: mainMixerNode, format: mixerFormat)
    
    /// The pitch of the audio (higher = deeper, 0 = normal)
    timeEffect.pitch = 1200 * 0
    
    /// The speed of the audio (higher = faster, 1 = noral)
    timeEffect.rate = 1
    
    // Player related
    engine.attach(player)
    engine.attach(timeEffect)

    engine.connect(
      player,
      to: timeEffect,
      format: inputFormat)
    engine.connect(
      timeEffect,
      to: engine.mainMixerNode,
      format: inputFormat)
  }
  
  private func playBack() {
    // Stop recording first (remove tap on input node)
    stopRecording()
    
    state = .playback
    
    // Playback "latest.caf" file
    guard let file: AVAudioFile = try? readFileURL() else {
      print("File not found")
      return
    }
        
    scheduleAudioFile(file)
  }
  
  private func scheduleAudioFile(_ file: AVAudioFile) {
    guard needsFileScheduled else { return }
    
    needsFileScheduled = false
    
    let audioLengthSamples = file.length // number of frames
    let audioSampleRate = file.processingFormat.sampleRate
    
    let audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
    print("Total Lenght (including silence): \(audioLengthSeconds)")
    
    // rate of frames (hz) * silence threshold (seconds)
    let framesDiscounted = file.processingFormat.sampleRate * AudioRecorder.SilenceThreshold
    let actualAudioLengthSeconds = (Double(audioLengthSamples) - framesDiscounted) / audioSampleRate
    print("Actual Length: \(actualAudioLengthSeconds)")
    
    player.scheduleSegment(file, startingFrame: .zero, frameCount: AVAudioFrameCount((Double(audioLengthSamples) - framesDiscounted)), at: nil, completionCallbackType: .dataPlayedBack, completionHandler: { _ in
      print("Played Segment")
      DispatchQueue.main.async {
        self.isPlaying = false
        self.needsFileScheduled = true
        self.disconnectVolumeTap()
        self.state = .stopped
      }
    })
    
    if engine.isRunning {
      player.play()
      connectVolumeTap()
    }
  }
  
  private func startTimer() {
    DispatchQueue.main.async {
      self.silenceTimer = Timer.scheduledTimer(withTimeInterval: AudioRecorder.SilenceThreshold, repeats: false, block: { _ in
        self.state = .stopped
      })
    }
  }
  private func endTimer() {
    silenceTimer.invalidate()
  }
}

// Methods for invoking the recorder
extension AudioRecorder {
  
  func startRecording() {
    let tapNode: AVAudioNode = engine.inputNode
    let format = tapNode.outputFormat(forBus: 0)
    
    var file: AVAudioFile?
    
    do {
      file = try writeFileURL(format: format)
    } catch {
      print("Error: \(error)")
    }
    
    /// Installs a tap to get average power of ongoing audio
    tapNode.installTap(onBus: 0, bufferSize: 4096, format: format, block: { [weak self] buffer, time in
      // Determine average power and whether or not to record or to wait for silence
      guard let self = self, let channelData = buffer.floatChannelData else {
        return
      }
      
      let channelDataValue = channelData.pointee
      let channelDataValueArray = stride(
        from: 0,
        to: Int(buffer.frameLength),
        by: buffer.stride)
        .map { channelDataValue[$0] }
      
      let rms = sqrt(channelDataValueArray.map {
        return $0 * $0
      }.reduce(0, +) / Float(buffer.frameLength))
      
      let avgPower = 20 * log10(rms)
      let meterLevel = self.scaledPower(power: avgPower)
      
      if meterLevel >= 0.60 {
        print("NOT Silent && Meter Level: \(meterLevel)")
        // If not recording already, start recording
        self.endTimer()
        self.state = .recording
      } else {
        print("SILENT")
        // If it *was* recording, start a timer for some number of seconds which would get invalidated if the meter level goes back above 0.5,
        // if and when the x number of seconds of silence passes, playback audio that was saved
        if !self.silenceTimer.isValid {
          self.startTimer()
        }
      }
      
      // Recording
      if self.state == .recording {
        // save data to a "latest.caf" file
        print("Recording")
        try? file?.write(from: buffer)
      } else {
        print("Not Recording")
      }
    })

    do {
      try engine.start()
    } catch {
      print("Error: \(AudioRecordingError.recording(error: error))")
    }
  }
  
  func resumeRecording() {
    do {
      try engine.start()
    } catch {
      print("Error: \(AudioRecordingError.recording(error: error))")
    }
  }
  
  func pauseRecording() {
    engine.pause()
  }
  
  func stopRecording() {
    engine.inputNode.removeTap(onBus: 0)
  }
}

// Helper method to determine scaled power of audio
extension AudioRecorder {
  private func scaledPower(power: Float) -> Float {
    guard power.isFinite else {
      return 0.0
    }
    
    let minDb: Float = -80
    
    if power < minDb {
      return 0.0
    } else if power >= 1.0 {
      return 1.0
    } else {
      return (abs(minDb) - abs(power)) / abs(minDb)
    }
  }
}

// Converts AVAudioPCMBuffer into NSData
fileprivate extension AVAudioPCMBuffer {
  func toNSData() -> NSData {
    let channelCount = 1  // given PCMBuffer channel count is 1
    let channels = UnsafeBufferPointer(start: self.floatChannelData, count: channelCount)
    let ch0Data = NSData(bytes: channels[0], length:Int(self.frameCapacity * self.format.streamDescription.pointee.mBytesPerFrame))
    return ch0Data
  }
}

// Converts NSData to PCMBuffer
fileprivate extension NSData {
  func toPCMBuffer(sampleRate: Double) -> AVAudioPCMBuffer? {
    guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false),
          let PCMBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(self.length) / audioFormat.streamDescription.pointee.mBytesPerFrame) else { return nil }
    PCMBuffer.frameLength = PCMBuffer.frameCapacity
    let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: Int(PCMBuffer.format.channelCount))
    self.getBytes(UnsafeMutableRawPointer(channels[0]) , length: self.length)
    return PCMBuffer
  }
}

extension AudioRecorder {
  func adjustPitch(to pitch: Pitch) {
    timeEffect.pitch = 1200 * pitch.rawValue
  }
  
  func adjustSpeed(to speed: Speed) {
    timeEffect.rate = speed.rawValue
  }
  
  private func connectVolumeTap() {
    let format = engine.mainMixerNode.outputFormat(forBus: 0)
    
    engine.mainMixerNode.installTap(
      onBus: 0,
      bufferSize: 1024,
      format: format
    ) { buffer, _ in
      guard let channelData = buffer.floatChannelData else {
        return
      }
      
      let channelDataValue = channelData.pointee
      let channelDataValueArray = stride(
        from: 0,
        to: Int(buffer.frameLength),
        by: buffer.stride)
        .map { channelDataValue[$0] }
      
      let rms = sqrt(channelDataValueArray.map {
        return $0 * $0
      }
                      .reduce(0, +) / Float(buffer.frameLength))
      
      let avgPower = 20 * log10(rms)
      let meterLevel = self.scaledPower(power: avgPower)
      
      print("Meter Level: \(meterLevel)")
      if meterLevel >= 0.5 {
        nounGameScene.startMouthMoving()
      } else {
        nounGameScene.stopMouthMoving()
      }
    }
  }
  
  private func disconnectVolumeTap() {
    print("Disconnected")
    nounGameScene.stopMouthMoving()
    engine.mainMixerNode.removeTap(onBus: 0)
  }
}
