//
//  NounPlayground.ViewModel.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-01-05.
//

import SwiftUI
import Services

extension NounPlayground {
  
  final class ViewModel: ObservableObject {
    
    enum State {
      /// An initial state of showing a coachmark to guide the user
      case coachmark
      
      /// The user is not recording but is talking and the noun is repeating
      case freestyle
      
      /// The user is recording their speech along with their noun's reptition
      case recording
      
      /// The user has completed recording and is ready to share, save, or start over
      case share
    }
    
    @Published private(set) var showAudioPermissionDialog = false
    @Published private(set) var selectedEffect: VoiceChangerEffect = .alien
    @Published private(set) var isRecording = false
    @Published private(set) var state: State = .coachmark
    
    private let voiceChangerEngine: VoiceChangerEngine
    
    init(voiceChangerEngine: VoiceChangerEngine = AVVoiceChangerEngine()) {
      self.voiceChangerEngine = voiceChangerEngine
      
      if voiceChangerEngine.recordPermission == .undetermined {
        showAudioPermissionDialog = true
      }
    }
    
    deinit {
      stopListening()
    }
    
    /// Requests the user's permission to use the microphone
    @MainActor
    func requestMicrophonePermission() {
      Task {
        do {
          let isGranted = try await voiceChangerEngine.requestRecordPermission()
          
          showAudioPermissionDialog = false
          
        } catch { }
      }
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func startListening() {
//      voiceChangerEngine.startListening()
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func stopListening() {
      voiceChangerEngine.stopListening()
    }
    
    /// Updates the currently selected effect
    func updateEffect(to effect: VoiceChangerEffect) {
      selectedEffect = effect
    }
    
    /// Toggles the `isRecording` boolean value
    func toggleRecording() {
      isRecording.toggle()
    }
    
    /// Updates the setting store with a `true`  value and toggles the bottom sheet presentation boolean value
    func didEnableAudioPermissions() {
      showAudioPermissionDialog.toggle()
    }
    
    /// Updates the view state to a new state
    func updateState(to newState: State) {
      state = newState
    }
  }
}

extension VoiceChangerEffect {
  
  var icon: Image {
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
