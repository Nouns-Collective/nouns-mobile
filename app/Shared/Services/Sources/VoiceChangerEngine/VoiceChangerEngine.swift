//
//  VoiceChangerEngine.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import AVFAudio

public typealias VoiceChangerEngine = AudioAuthorization & AudioMixer

public enum VoiceChangerEffect: Int, CaseIterable {
  case robot
  case alien
  case chipmunk
  case monster
}

public protocol AudioMixer {
  
  func configure() throws
  
  func startListening() async throws
  
  func stopListening()
}

public class AVVoiceChangerEngine: AudioMixer {
  
  public private(set) var isRecording = false
  
  private let audioEngine = AVAudioEngine()
  private let unitTimePitch = AVAudioUnitTimePitch()
  
  /// A reader node for the recoded file captured from the hardware input (mic).
  private let recordedFilePlayer = AVAudioPlayerNode()
  
  /// An object that represents an redcoded audio file.
  private var recordedFile: AVAudioFile?
  
  /// Calculates the recorded audio powers to determine the status `sound` or `silence`.
  private let recorderPowerMeter = PowerMeter()
  
  // Get the native audio format of the engine's input bus.
  private var inputFormat: AVAudioFormat
  
  // Set an output format.
  private var outputFormat: AVAudioFormat?
  
  public init() {
    // Create a node player to playback the recorded voice.
    audioEngine.attach(recordedFilePlayer)
    
    // Get the native audio format of the engine's input bus.
    inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
    
    outputFormat = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: inputFormat.sampleRate,
      channels: 1,
      interleaved: false
    )
  }
  
  public func configure() throws {
    // Record using the mic.
    let input = audioEngine.inputNode
    try input.setVoiceProcessingEnabled(true)
    
    // Create a mixer node to convert the input.
    let output = audioEngine.outputNode
    let mainMixer = audioEngine.mainMixerNode
    
    audioEngine.connect(recordedFilePlayer, to: mainMixer, format: inputFormat)
    audioEngine.connect(mainMixer, to: output, format: outputFormat)
    
    input.installTap(onBus: 0, bufferSize: 256, format: outputFormat) { [weak self] buffer, _ in
      guard let self = self else { return }
      
      let audioStatus = self.recorderPowerMeter.process(buffer: buffer)
      switch audioStatus {
      case .sound:
        self.persistStreamingBuffer(buffer)
        
      case .silence:
        self.processSilence()
      }
    }
    
    //    // Attach the mixer to the microphone input and the output of the audio engine.
    //    audioEngine.connect(audioEngine.inputNode, to: mixerNode, format: inputFormat)
    //    audioEngine.connect(mixerNode, to: audioEngine.mainMixerNode, format: outputFormat)
    
    //    audioEngine.attach(unitTimePitch)
    //    audioEngine.connect(unitTimePitch, to: audioEngine.mainMixerNode, format: inputFormat)
    
    audioEngine.prepare()
  }
  
  private func persistStreamingBuffer(_ buffer: AVAudioPCMBuffer) {
    guard let outputFormat = outputFormat else {
      return
    }
    
    do {
      if recordedFile == nil {
        recordedFile = try AVAudioFile(
          forWriting: generateUniqueFileURL(),
          settings: outputFormat.settings
        )
      }
      
      try recordedFile?.write(from: buffer)
      
    } catch {
      print("⚠️ Could not write buffer: \(error)")
    }
  }
  
  private func processSilence() {
    recordedFile = nil
    
    //    guard let outputFormat = outputFormat else {
    //      return
    //    }
    //
    //    do {
    //      recordedFile = try AVAudioFile(
    //        forWriting: generateUniqueFileURL(),
    //        settings: outputFormat.settings
    //      )
    //    } catch {
    //      print("⚠️ Could not represents an audio file: \(error)")
    //    }
    
  }
  
  public func startListening() async throws {
    guard !audioEngine.isRunning else { return }
    
    guard recordPermission == .granted else {
      return print("⚠️ Record permission not granted.")
    }
    
    try audioEngine.start()
  }
  
  public func stopListening() {
    guard audioEngine.isRunning else { return }
    
    audioEngine.stop()
  }
  
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("caf")
    return fileURL
  }
}

/// The record permission status.
public enum RecordPermission {
  case undetermined
  case denied
  case granted
}

public protocol AudioAuthorization {
  
  var recordPermission: RecordPermission { get }
  
  func requestRecordPermission() async throws -> Bool
}

extension AVVoiceChangerEngine: AudioAuthorization {
  
  private var audioSession: AVAudioSession {
    AVAudioSession.sharedInstance()
  }
  
  public var recordPermission: RecordPermission {
    switch audioSession.recordPermission {
    case .granted:
      return .granted
      
    case .undetermined:
      return .undetermined
      
    case .denied:
      return .denied
      
    @unknown default:
      fatalError("Unprocessed record authorization case.")
    }
  }
  
  public func requestRecordPermission() async throws -> Bool {
    try audioSession.setCategory(.playAndRecord)
    return await withCheckedContinuation({ continuation in
      audioSession.requestRecordPermission { granted in
        continuation.resume(returning: granted)
      }
    })
  }
}
