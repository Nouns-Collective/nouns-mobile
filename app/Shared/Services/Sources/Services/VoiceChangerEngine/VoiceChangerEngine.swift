//
//  VoiceChangerEngine.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import AVFoundation
import Combine
import os

/// Auto-Listening & record  & applies pre-built effects.
public class VoiceChangerEngine: ObservableObject {
  
  /// Various modes to capture the voice.
  public enum CaptureMode {
    
    /// Voice capture is based on sound analysis where speech & slience are the triggers.
    case auto
    
    /// Voice capture is based on manual managment with the given assiated value `isRecording`.
    case manual(_ isRecording: Bool)
  }
  
  /// Vairous voice change states.
  public enum CaptureState: String {
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
  @Published public private(set) var outputFileURL: URL? {
    didSet {
      objectWillChange.send()
    }
  }
  
  /// The current voice changer state.
  @Published public private(set) var captureState: CaptureState = .idle {
    didSet {
      if oldValue != captureState {
        logger.debug("🏁🎙 Audio Engine is \(self.captureState.rawValue, privacy: .public)")
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
  
  /// States the mode currently applied to capture the voice.
  @Published public var captureMode: CaptureMode = .auto
  
  /// A boolean to indicate whether the start and stop of voice capture will be controlled
  /// manually instead of the sound analysis based on speech & silence.
  public var isVoiceCapturedUsingSoundAnalysis: Bool = true
  
  /// A boolean to enable persisting the voice recorded to the disk.
  public var isPersistenceEnabled: Bool = false
  
  /// Audio nodes, controls playback, and configures real-time rendering.
  private let audioEngine = AVAudioEngine()
  
  /// A reader node for the recoded file captured from the hardware input (mic).
  private let recordedFilePlayer = AVAudioPlayerNode()
  
  /// An object that represents an recorded audio file with no effect applied.
  private var voiceLessEffectOutput: VoiceCaptureOutput?
  
  /// An object that represents an redcoded audio file with the chosen effect applied
  private var voicePlusEffectOuput: VoiceCaptureOutput?
  
  /// Calculates the recorded audio powers to determine the status if `loud` or `silent`.
  private var audioStateDetector: AudioStateDetector?
  
  /// The index of a bus on an audio node while monitoring.
  private var outputBus: AVAudioNodeBus = 0
  
  /// A number of audio sample frames.
  private let bufferSize = AVAudioFrameCount(4096)
  
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "VoiceChangerEngine"
  )
  
  public init() {
    
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
    try prepareAudioEngineToRecordSpeech()
    try prepareAudioEngine(forEffect: effect)
    
    audioEngine.prepare()
    try audioEngine.start()
  }
  
  /// Stops the engine & removes all inputs.
  public func stop() {
    autoreleasepool {
      if audioEngine.isRunning {
        audioEngine.stop()
//        try? audioEngine.inputNode.setVoiceProcessingEnabled(false)
        audioEngine.inputNode.removeTap(onBus: outputBus)
        audioEngine.mainMixerNode.removeTap(onBus: outputBus)
      }
      
      audioStateDetector = nil
    }
    stopAudioSession()
  }
  
  private func prepareAudioEngine(forEffect effect: VoiceChangerEngine.Effect) throws {
    audioEngine.attach(recordedFilePlayer)
    
    // Plug-in all audio units to apply related effect.
    var outputAudioUnit: AVAudioNode = recordedFilePlayer
    for inputAudioUnit in effect.unit.audioUnits {
      audioEngine.attach(inputAudioUnit)
      audioEngine.connect(outputAudioUnit, to: inputAudioUnit, format: nil)
      outputAudioUnit = inputAudioUnit
    }
    
    audioEngine.connect(outputAudioUnit, to: audioEngine.mainMixerNode, format: nil)
    
    let mainMixer = audioEngine.mainMixerNode
    let outputFormat = mainMixer.outputFormat(forBus: outputBus)
    voicePlusEffectOuput = try VoiceCaptureOutput(audioFormat: outputFormat)
    
    mainMixer.installTap(
      onBus: outputBus,
      bufferSize: bufferSize,
      format: outputFormat
    ) { [weak self] buffer, _ in

      guard let self = self else { return }

      // While the captured voice with effect is playing, persist the buffer to the disk.
      guard self.captureState == .playing else { return }
      
      do {
        try self.voicePlusEffectOuput?.persistStream(buffer)

      } catch {
        self.logger.error("⚠️ 🔊 Could not persist buffer with effect: \(error.localizedDescription, privacy: .public)")
      }
    }
  }
  
  private func prepareAudioEngineToRecordSpeech() throws {
    // Record using the mic.
    let input = audioEngine.inputNode
    let outputFormat = input.outputFormat(forBus: outputBus)
    audioStateDetector = try MLAudioStateDetector(audioFormat: outputFormat)
    voiceLessEffectOutput = try VoiceCaptureOutput(audioFormat: outputFormat)
//    try input.setVoiceProcessingEnabled(true)
    
    input.installTap(
      onBus: outputBus,
      bufferSize: bufferSize,
      format: outputFormat
    ) { [weak self] buffer, when in
      
      guard let self = self else { return }
      
      // Stop recording if the previous recording is being played.
      guard self.captureState != .playing else { return }
      
      switch self.captureMode {
      case .manual(let isRecoding):
        self.handleManualRecording(for: buffer, isRecording: isRecoding)
        
      case .auto:
        self.handleAutoRecording(for: buffer, sampleTime: when.sampleTime)
      }
    }
  }
  
  private func handleManualRecording(for buffer: AVAudioPCMBuffer, isRecording: Bool) {
    // The playback is done uppon request.
    guard isRecording else { return }
    
    do {
      try voiceLessEffectOutput?.persistStream(buffer)

    } catch {
      logger.error("⚠️ 🔊 Could not persist buffer without effect: \(error.localizedDescription, privacy: .public)")
    }
  }
  
  private func handleAutoRecording(for buffer: AVAudioPCMBuffer, sampleTime: AVAudioFramePosition) {
    guard let audioStateDetector = audioStateDetector else {
      return
    }

    // Process the current samples to find audio status.
    audioStateDetector.process(buffer: buffer, sampleTime: sampleTime)
    
    switch audioStateDetector.status {
    case .speech:
      DispatchQueue.main.async {
        // Update the state to in the recording state.
        self.captureState = .recording
      }
      
      do {
        try voiceLessEffectOutput?.persistStream(buffer)

      } catch {
        logger.error("⚠️ 🔊 Could not persist buffer without effect: \(error.localizedDescription, privacy: .public)")
      }

    case .silence:
      guard audioStateDetector.previousState == .speech else {
        return
      }
      
      playbackCapturedVoice()

    case .undefined:
      break
    }
  }
  
  // MARK: - Audio Units Effects
  
  public func playback() -> AnyPublisher<TimeInterval, Never> {
    let progress = PassthroughSubject<TimeInterval, Never>()
    
    let duration = voiceLessEffectOutput?.duration ?? 0
    
    let lastRenderTimeCancellable = recordedFilePlayer.lastRenderTime.publisher
//      .compactMap { nodeTime in
//        self.recordedFilePlayer.playerTime(forNodeTime: nodeTime)
//      }
      .sink { playerTime in
        guard self.recordedFilePlayer.isPlaying else {
          return progress.send(completion: .finished)
        }
        
        let currentTime = TimeInterval(playerTime.sampleTime) / playerTime.sampleRate
        let fractionCompletion = currentTime / duration
        progress.send(fractionCompletion)
      }
    
    return progress.handleEvents { _ in
      self.playbackCapturedVoice()
    } receiveCompletion: { _ in
      lastRenderTimeCancellable.cancel()
    } receiveCancel: {
      lastRenderTimeCancellable.cancel()
    }
    .eraseToAnyPublisher()
  }
  
  /// Plays back the voice with effect.
  private func playbackCapturedVoice() {
    // Access the voice captured and persisted to the disk.
    guard let voiceLessEffectOutput = voiceLessEffectOutput else {
      return
    }
    
    recordedFilePlayer.scheduleFile(voiceLessEffectOutput.audioFile, at: nil) { [weak self] in
      // When the play of the audio without effect has stopped.
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        // Publish the location of the audio recorded with the chosen effect.
        self.outputFileURL = self.voicePlusEffectOuput?.audioFile.url
        
        self.logger.info("📍 🔊 Audio with effect stored at \(self.outputFileURL?.absoluteString ?? "💥 Unavailable")")
      }
      
      // Resets the voice capture & effect applied to the listening state.
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        // Deletes the audio with no effect after the playback.
        self.voiceLessEffectOutput?.reset()
        
        self.captureState = .idle
        self.audioProcessingState = .silence
      }
    }
    
    DispatchQueue.main.async {
      self.captureState = .playing
      self.audioProcessingState = .speech
    }
    
    recordedFilePlayer.play()
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
