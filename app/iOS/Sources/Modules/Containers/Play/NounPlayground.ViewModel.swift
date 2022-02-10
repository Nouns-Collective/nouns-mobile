//
//  NounPlayground.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI
import Services
import Combine
import os

extension NounPlayground {
  
  final class ViewModel: ObservableObject {
    
    enum State {
      
      /// The user is not recording but is talking and the noun is repeating
      case freestyle
      
      /// The user is recording their speech along with their noun's reptition, then persisted to the disk.
      case recording
      
      /// The user has completed recording and is ready to share, save, or start over
      case share
    }
    
    /// The current state of the playground where it switches between simply playing
    /// the voice with effect `freestyle`, adding the audio persistence
    /// option `recording`, or allowing the user to share it `share`.
    @Published private(set) var state: State = .freestyle {
      didSet {
        switch state {
        case .freestyle:
          break
        case .recording:
          break
        case .share:
          break
        }
      }
    }
    
    /// Determines whether the user request to record and store audio on disk for sharing.
    @Published var isRecording = false
    
    /// Shows the audio permission sheet to request voice capture permission.
    @Published private(set) var showAudioPermissionDialog = false
    
    /// Shows the audio settings sheet when the voice capture permission has been denied or restricted.
    @Published private(set) var showAudioSettingsSheet = false
    
    /// A Boolean value indicates whether the noun is talking.
    @Published private(set) var isTalking = false
    
    public var audioProcessingState: AudioStatus {
      voiceChangerEngine.audioProcessingState
    }
    
    public var currentEffect: VoiceChangerEngine.Effect {
      voiceChangerEngine.effect
    }
    
    public var isRequestingAudioPermission: Bool {
      showAudioSettingsSheet || showAudioPermissionDialog
    }
    
    private let screenRecorder: ScreenRecorder
    private let voiceChangerEngine: VoiceChangerEngine
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger(
      subsystem: "wtf.nouns.ios",
      category: "Noun Playground"
    )
    
    init(
      voiceChangerEngine: VoiceChangerEngine = VoiceChangerEngine(),
      screenRecorder: ScreenRecorder = CAScreenRecorder()
    ) {
      self.voiceChangerEngine = voiceChangerEngine
      self.screenRecorder = screenRecorder
      
      handleVoiceCapturePermission()
      
      // Observes the location of voice with the effect applied, then display the share experience.
      voiceChangerEngine.outputFileURL.publisher
        .sink { [weak self] audioFileURLWithEffect in
          
          self?.state = .share
          
          self?.logger.debug("✅ 🔊 Successully persisted the audio with effect at: \(audioFileURLWithEffect.absoluteString, privacy: .public)")
        }
        .store(in: &cancellables)
      
      voiceChangerEngine.$audioProcessingState
        .sink { [weak self] status in
          
          self?.isTalking = status == .speech
        }
        .store(in: &cancellables)
    }
    
    deinit {
      stopListening()
    }
    
    // MARK: - Voice Capture
    
    /// Requests the user's permission to use the microphone
    @MainActor
    func requestMicrophonePermission() {
      Task {
        await voiceChangerEngine.requestRecordPermission()
        handleVoiceCapturePermission()
      }
    }
    
    private func handleVoiceCapturePermission() {
      switch voiceChangerEngine.recordPermission {
      case .undetermined:
        showAudioPermissionDialog = true
        
      case .granted:
        showAudioPermissionDialog = false
        startListening()
        
      case .denied, .restricted:
        showAudioSettingsSheet = true
      }
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func startListening() {
      do {
        try voiceChangerEngine.prepare()
      } catch {
        logger.error("💥 🎙 Unable to prepare the voice changer engine: \(error.localizedDescription, privacy: .public)")
      }
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func stopListening() {
      voiceChangerEngine.stop()
    }
    
    // MARK: - Audio Effects
    
    /// Updates the currently selected effect
    func updateEffect(to effect: VoiceChangerEngine.Effect) {
      voiceChangerEngine.effect = effect
    }
    
    /// Updates the view state to a new state
    func updateState(to newState: State) {
      state = newState
    }
    
    // MARK: - Screen Recorder / Audio Effect
    
    @MainActor
    func stopRecording() {
      Task {
        do {
          let url = try await screenRecorder.stopRecording()
          
        } catch {
          logger.error("💥 An error occurred while stopping screen recording: \(error.localizedDescription, privacy: .public)")
        }
      }
    }
  }
}

extension VoiceChangerEngine.Effect {
  
  var image: Image {
    switch self {
    case .robot:
      return Image.robot
    case .alien:
      return Image.alien
    case .chipmunk:
      return Image.chipmunk
    case .monster:
      return Image.monster
    }
  }
}
