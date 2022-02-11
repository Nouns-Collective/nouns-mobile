//
//  VoiceChangerEngine.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import AVFoundation
import os

/// Auto-Listening & record  & applies pre-built effects.
public class VoiceChangerEngine: ObservableObject {
  
  /// Vairous voice change states.
  public enum State: String {
    case idle
    case recording
    case playing
  }
  
  /// Various effects to apply to the recorded audio.
  public enum Effect: Int, CaseIterable {
    case robot
    case alien
    case chipmunk
    case monster
  }
  
  /// The location of the audio file after applying the chosen effect.
  @Published public private(set) var outputFileURL: URL?
  
  /// The current voice changer state.
  @Published public private(set) var state: State = .idle {
    didSet {
      if oldValue != state {
        logger.debug("🏁🎙 Audio Engine is \(self.state.rawValue, privacy: .public)")
      }
    }
  }
  
  /// Effect currently applied to the audio recorded.
  @Published public var effect: VoiceChangerEngine.Effect = .alien {
    didSet { try? prepare() }
  }
  
  /// Determines the state of the audio being processed.
  @Published public private(set) var audioProcessingState: AudioStatus = .undefined {
    didSet {
      logger.debug("🔊 Audio is processed as \(self.audioProcessingState.rawValue)")
    }
  }
 
  /// Audio nodes, controls playback, and configures real-time rendering.
  private let audioEngine = AVAudioEngine()
  
  /// A reader node for the recoded file captured from the hardware input (mic).
  private let recordedFilePlayer = AVAudioPlayerNode()
  
  /// An object that represents an recorded audio file with no effect applied.
  private var recordedFileWithNoEffect: AVAudioFile?
  
  /// An object that represents an redcoded audio file with the chosen effect applied
  private var recordedFileWithEffect: AVAudioFile?
  
  /// Calculates the recorded audio powers to determine the status if `loud` or `silent`.
  private var audioStateDetector: AudioStateDetector?
  
  /// The index of a bus on an audio node while monitoring.
  private var outputBus: AVAudioNodeBus = 0
  
  /// Set an output format.
  private var outputFormat: AVAudioFormat
  
  /// A number of audio sample frames.
  private let bufferSize = AVAudioFrameCount(4096)
  
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "VoiceChangerEngine"
  )
  
  public init() {
    outputFormat = audioEngine.inputNode.outputFormat(forBus: outputBus)
  }
  
  deinit {
    stop()
  }
  
  /// Prepares the engine to configure all inputs and outputs for
  /// recording, then apply the selected effect.
  public func prepare() throws {
    // It's needed to stop and reset the audio engine before
    // creating a new one to avoid crashing & consider the new configuration.
    stop()
    
    try startAudioSession()
    
    audioStateDetector = try MLAudioStateDetector(audioFormat: outputFormat)
    try prepareAudioEngineToRecordSpeech()
    prepareAudioEngine(forEffect: effect)
    
    audioEngine.prepare()
    try audioEngine.start()
  }
  
  /// Stops the engine & removes all inputs.
  public func stop() {
    autoreleasepool {
      if audioEngine.isRunning {
        audioEngine.stop()
//        try? audioEngine.inputNode.setVoiceProcessingEnabled(false)
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.mainMixerNode.removeTap(onBus: 0)
      }
      
      audioStateDetector = nil
    }
    stopAudioSession()
  }
  
  private func prepareAudioEngine(forEffect effect: VoiceChangerEngine.Effect) {
    audioEngine.attach(recordedFilePlayer)
    
    // Plug-in all audio units to apply related effect.
    var outputAudioUnit: AVAudioNode = recordedFilePlayer
    for inputAudioUnit in effect.unit.audioUnits {
      audioEngine.attach(inputAudioUnit)
      audioEngine.connect(outputAudioUnit, to: inputAudioUnit, format: nil)
      outputAudioUnit = inputAudioUnit
    }
    
    audioEngine.connect(outputAudioUnit, to: audioEngine.mainMixerNode, format: nil)
    
    audioEngine.mainMixerNode.installTap(
      onBus: outputBus,
      bufferSize: bufferSize,
      format: nil
    ) { [weak self] buffer, _ in

      guard let self = self, self.state == .playing else { return }

      do {
        try self.persistStreamingAudioBuffer(
          buffer,
          audioFile: &self.recordedFileWithEffect
        )

      } catch {
        self.logger.error("⚠️ 🔊 Could not persist buffer with effect:  \(error.localizedDescription, privacy: .public)")
      }
    }
  }
  
  private func prepareAudioEngineToRecordSpeech() throws {
    // Record using the mic.
    let input = audioEngine.inputNode
//    try input.setVoiceProcessingEnabled(true)
    
    input.installTap(
      onBus: outputBus,
      bufferSize: bufferSize,
      format: outputFormat
    ) { [weak self] buffer, when in
      
      guard let self = self, let audioStateDetector = self.audioStateDetector else {
        return
      }
      
      // Stop recording if the previous recording is being played.
      guard self.state != .playing else { return }
      
      // Process the current samples to find audio status.
      audioStateDetector.process(buffer: buffer, sampleTime: when.sampleTime)
      
      switch audioStateDetector.status {
      case .speech:
        // Update the state to in the recording state.
        self.state = .recording
        
        do {
          try self.persistStreamingAudioBuffer(
            buffer,
            audioFile: &self.recordedFileWithNoEffect
          )
          
        } catch {
          self.logger.error("⚠️ 🔊 Could not persist buffer without effect:  \(error.localizedDescription, privacy: .public)")
        }

      case .silence:
        self.processVoiceCaptureSilence()
        
      case .undefined:
        break
      }
    }
  }
  
  // MARK: - Audio Units Effects
  
  private func applyEffect(file: AVAudioFile) {
    recordedFilePlayer.scheduleFile(file, at: nil) { [weak self] in
      guard let self = self else { return }
      
      // Deletes the audio with no effect after the playback.
      self.deleteFile(at: file.url)
      
      DispatchQueue.main.async {
        // Publish the location of the audio recorded with the chosen effect.
        self.outputFileURL = self.recordedFileWithEffect?.url
      }
      
      // Resets the voice capture & effect applied to the listening state.
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.state = .idle
        self.audioProcessingState = .silence
      }
    }
    
    DispatchQueue.main.async {
      self.state = .playing
      self.audioProcessingState = .speech
    }
    
    recordedFilePlayer.play()
  }
  
  // MARK: - Process recorded voice
  
  private func persistStreamingAudioBuffer(
    _ buffer: AVAudioPCMBuffer,
    audioFile: inout AVAudioFile?
  ) throws {
      audioFile = try newAudioFile(audioFile)
      try audioFile?.write(from: buffer)
  }
  
  private func processVoiceCaptureSilence() {
    guard let recordedFile = recordedFileWithNoEffect else {
      return
    }
    
    applyEffect(file: recordedFile)
    recordedFileWithNoEffect = nil
  }
  
  /// Generates a new `AVAudioFile` if it does not exist.
  private func newAudioFile(_ audioFile: AVAudioFile?) throws -> AVAudioFile {
    guard let audioFile = audioFile else {
      return try AVAudioFile(
        forWriting: generateUniqueFileURL(),
        settings: outputFormat.settings
      )
    }
    
    return audioFile
  }
  
  // MARK: - File management
  
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("caf")
    return fileURL
  }
  
  private func deleteFile(at fileURL: URL) {
    do {
      try FileManager.default.removeItem(at: fileURL)
    } catch {
      logger.error("⚠️ 🔊 Couldn't delete audio file: \(error.localizedDescription, privacy: .public)")
    }
  }
}

/// Requests the user’s permission for recording the audio media type.
extension VoiceChangerEngine: AudioAuthorization {
  // MARK: - AudioAuthorization
  
  public var recordPermission: RecordPermission {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
      return .granted
      
    case .notDetermined:
      return .undetermined
      
    case .restricted:
      return .restricted
      
    case .denied:
      return .denied
      
    @unknown default:
      fatalError("💥 🔊 unknown authorization status for microphone access.")
    }
  }
  
  @discardableResult
  public func requestRecordPermission() async -> Bool {
    await AVCaptureDevice.requestAccess(for: .audio)
  }
  
  /// Configures and activates an `AVAudioSession`.
  ///
  /// If this method throws an error, it calls `stopAudioSession` to reverse its effects.
  private func startAudioSession() throws {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
      try audioSession.setMode(.default)
      try audioSession.setActive(true)
    } catch {
      stopAudioSession() 
      throw error
    }
  }
  
  /// Deactivates the app's AVAudioSession.
  private func stopAudioSession() {
    autoreleasepool {
      let audioSession = AVAudioSession.sharedInstance()
      try? audioSession.setActive(false)
    }
  }
}
