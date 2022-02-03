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
    @Published private(set) var isRecording = false
    @Published private(set) var state: State = .coachmark
    @Published private(set) var dismissPlayExperience = false
    
    public let screenRecorder: ScreenRecorder
    
    public var audioProcessingState: AudioStatus {
      voiceChangerEngine.audioProcessingState
    }
    
    public let voiceChangerEngine: VoiceChangerEngine
    
    public var currentEffect: VoiceChangerEngine.Effect {
      voiceChangerEngine.effect
    }
    
    init(voiceChangerEngine: VoiceChangerEngine = VoiceChangerEngine(), screenRecorder: ScreenRecorder = CAScreenRecorder()) {
      self.voiceChangerEngine = voiceChangerEngine
      self.screenRecorder = screenRecorder
      
      handleRecordPermission()
    }
    
    deinit {
      stopListening()
    }
    
    private func handleRecordPermission() {
      switch voiceChangerEngine.recordPermission {
      case .undetermined:
        showAudioPermissionDialog = true
        
      case .granted:
        showAudioPermissionDialog = false
        startListening()
        
      case .denied:
        dismissPlayExperience = true
      }
    }
    
    /// Requests the user's permission to use the microphone
    @MainActor
    func requestMicrophonePermission() {
      Task {
        do {
          try await voiceChangerEngine.requestRecordPermission()
          handleRecordPermission()
          
        } catch { }
      }
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func startListening() {
      do {
        try voiceChangerEngine.prepare()
      } catch { }
    }
    
    /// Toggles the audio service to start listening to the user and calculating the average power / volume of the micrphone input
    func stopListening() {
      voiceChangerEngine.stop()
    }
    
    /// Updates the currently selected effect
    func updateEffect(to effect: VoiceChangerEngine.Effect) {
      voiceChangerEngine.setEffect(to: effect)
    }
    
    /// Updates the view state to a new state
    func updateState(to newState: State) {
      state = newState
    }
    
    @MainActor
    func stopRecording() {
      Task {
        do {
          let videos = try await screenRecorder.stopRecording()
        } catch {
          print("An error has occured while creating video: \(error)")
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
