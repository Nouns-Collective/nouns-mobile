//
//  VoiceChangerEngine.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation
import AVFAudio

/// Various audio states.
public enum AudioStatus {
  case undefined
  case loud
  case silent
}

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
        print("🎙 Audio Engine is", state.rawValue)
      }
    }
  }
  
  /// Effect currently applied to the audio recorded.
  @Published public private(set) var effect: VoiceChangerEngine.Effect = .alien {
    didSet { try? prepare() }
  }
  
  /// Determines the state of the audio being processed.
  @Published public private(set) var audioProcessingState: AudioStatus = .undefined
 
  /// Audio nodes, controls playback, and configures real-time rendering.
  private let audioEngine = AVAudioEngine()
  
  /// A reader node for the recoded file captured from the hardware input (mic).
  private let recordedFilePlayer = AVAudioPlayerNode()
  
  /// An object that represents an redcoded audio file.
  private var recordedFile: AVAudioFile?
  
  /// Calculates the recorded audio powers to determine the status if `loud` or `silent`.
  private let silenceFinder = SilenceFinder()
  
  // Get the native audio format of the engine's input bus.
  private var inputFormat: AVAudioFormat
  
  // Set an output format.
  private var outputFormat: AVAudioFormat?
    
  public init() {
    // Get the native audio format of the engine's input bus.
    inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        
    outputFormat = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: inputFormat.sampleRate,
      channels: 1,
      interleaved: false
    )
  }
  
  private func configureAudioSession() {
    do {
      // Set default output audio to speaker
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
    } catch {
      print("🎤🛑 AVAudioSession could not set category with options")
    }
  }
  
  deinit {
    stop()
  }
  
  /// Prepares the engine to configure all inputs and outputs for
  /// recording, then apply the selected effect.
  public func prepare() throws {
    guard recordPermission == .granted else {
      print("🎤🛑 User hasn't granted microphone recording permissions")
      return
    }
        
    // It's needed to stop and reset the audio engine before
    // creating a new one to avoid crashing & consider the new configuration.
    stop()
    
    configureAudioSession()
    
    try prepareAudioEngineToRecord()
    prepareAudioEngine(forEffect: effect)
    
    audioEngine.prepare()
    try start()
  }
  
  public func start() throws {
    guard !audioEngine.isRunning else { return }
    try audioEngine.start()
  }
  
  /// Stops the engine & removes all inputs.
  public func stop() {
    
    // Remove tap on input and mainMixerNode before re-installing tap
    // This should be done regardless of whether or not the engine is currently running
    // as installing a tap on the input or mixer node while there are already taps installed
    // will result in a fatal error
    audioEngine.inputNode.removeTap(onBus: 0)
    audioEngine.mainMixerNode.removeTap(onBus: 0)
    
    guard audioEngine.isRunning else { return }
    
    audioEngine.stop()
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
    
    // Process and update the status to state when the mixed audio is `silent` or `loud`.
    audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 256, format: nil) { [weak self] buffer, _ in
      guard let self = self else { return }

      // Optimize to process only while playing the recorded audio.
      guard self.state == .playing else { return }

      // Process the current samples to find audio status.
      self.silenceFinder.process(buffer: buffer)
      self.audioProcessingState = self.silenceFinder.status
    }
  }
  
  private func prepareAudioEngineToRecord() throws {
    // Record using the mic.
    let input = audioEngine.inputNode
    try input.setVoiceProcessingEnabled(true)
    
    input.installTap(onBus: 0, bufferSize: 256, format: outputFormat) { [weak self] buffer, _ in
      guard let self = self else { return }
      
      // Stop recording if the previous recording is being played.
      guard self.state != .playing else { return }
      
      // Process the current samples to find audio status.
      self.silenceFinder.process(buffer: buffer)
      
      switch self.silenceFinder.status {
      case .undefined:
        break
        
      case .loud:
        self.persistStreamingBuffer(buffer)
        
      case .silent:
        self.processSilence()
      }
    }
  }
  
  // MARK: - Effects
  
  public func setEffect(to effect: Effect) {
    self.effect = effect
  }
  
  private func applyEffect(file: AVAudioFile) {
    recordedFilePlayer.scheduleFile(file, at: nil) { [weak self] in
      // Define a buffer to not record right after the player is stopped.
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self?.state = .idle
      }
    }
    
    state = .playing
    recordedFilePlayer.play()
  }
  
  // MARK: - Process recorded voice
  
  private func persistStreamingBuffer(_ buffer: AVAudioPCMBuffer) {
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
    guard let settings = outputFormat?.settings else { return }
    
    recordedFile = try AVAudioFile(
      forWriting: generateUniqueFileURL(),
      settings: settings
    )
  }
  
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("caf")
    return fileURL
  }
}
