//
//  VoiceChangerEngine.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.01.22.
//

import Foundation
import AVFoundation

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
  
  /// The current voice changer state.
  @Published public private(set) var state: State = .idle {
    didSet {
      if oldValue != state {
        print("🏁🎙 Audio Engine is", state.rawValue)
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
      print("🔊 Audio is processed as", audioProcessingState.rawValue)
    }
  }
 
  /// Audio nodes, controls playback, and configures real-time rendering.
  private let audioEngine = AVAudioEngine()
  
  /// A reader node for the recoded file captured from the hardware input (mic).
  private let recordedFilePlayer = AVAudioPlayerNode()
  
  /// An object that represents an redcoded audio file.
  private var recordedFile: AVAudioFile?
  
  /// Calculates the recorded audio powers to determine the status if `loud` or `silent`.
  private var audioStateDetector: AudioStateDetector?
  
  private var outputBus: AVAudioNodeBus = 0
  
  /// Set an output format.
  private var outputFormat: AVAudioFormat
  
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
  }
  
  private func prepareAudioEngineToRecordSpeech() throws {
    
    // Record using the mic.
    let input = audioEngine.inputNode
//    try input.setVoiceProcessingEnabled(true)
    let bufferSize = AVAudioFrameCount(4096)
    
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
        self.persistStreamingAudioBuffer(buffer)

      case .silence:
        self.processSilence()
        
      case .undefined:
        break
      }
    }
  }
  
  // MARK: - Audio Units Effects
  
  private func applyEffect(file: AVAudioFile) {
    recordedFilePlayer.scheduleFile(file, at: nil) { [weak self] in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self?.state = .idle
        self?.audioProcessingState = .silence
      }
    }
    
    state = .playing
    audioProcessingState = .speech
    recordedFilePlayer.play()
  }
  
  // MARK: - Process recorded voice
  
  private func persistStreamingAudioBuffer(_ buffer: AVAudioPCMBuffer) {
    do {
      // Update the state to in the recording state.
      state = .recording
      
      try newAudioFile()
      try recordedFile?.write(from: buffer)
      
    } catch {
      print("⚠️ Could not write buffer: \(error)")
    }
  }
  
  private func processSilence() {
    guard let recordedFile = recordedFile else {
      return
    }
    
    applyEffect(file: recordedFile)
    self.recordedFile = nil
  }
  
  /// Generates a new `AVAudioFile` if it does not exist.
  private func newAudioFile() throws {
    guard recordedFile == nil else { return }
    
    recordedFile = try AVAudioFile(
      forWriting: generateUniqueFileURL(),
      settings: outputFormat.settings
    )
  }
  
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("caf")
    return fileURL
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
      fatalError("unknown authorization status for microphone access.")
    }
  }
  
  @discardableResult
  public func requestRecordPermission() async throws -> Bool {
    return await AVCaptureDevice.requestAccess(for: .audio)
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
