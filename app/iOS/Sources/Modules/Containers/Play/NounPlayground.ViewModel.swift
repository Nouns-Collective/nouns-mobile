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
import AVFAudio

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
          startListening()
          
        case .recording:
          break
          
        case .share:
          stopListening()
        }
      }
    }
    
    /// Determines whether the user request to record and store audio on disk for sharing.
    @Published var isRecording = false {
      didSet {
        voiceChangerEngine.captureMode = .manual(isRecording)
      }
    }
    
    /// Shows the audio permission sheet to request voice capture permission.
    @Published private(set) var showAudioPermissionDialog = false
    
    /// Shows the audio settings sheet when the voice capture permission has been denied or restricted.
    @Published private(set) var showAudioSettingsSheet = false
    
    /// A Boolean value indicates whether the noun is talking.
    @Published private(set) var isNounTalking = false
    
    ///
    @Published private(set) var recordedTalkingNounVideoURL: URL?
    
    ///
    @Published private(set) var talkingNounRecordProgress: Double = 0.0
    
    ///
    public var audioProcessingState: AudioStatus {
      voiceChangerEngine.audioProcessingState
    }
    
    ///
    public var currentVoiceEffect: VoiceChangerEngine.Effect {
      voiceChangerEngine.effect
    }
    
    ///
    public var isRequestingAudioPermission: Bool {
      showAudioSettingsSheet || showAudioPermissionDialog
    }
    
    private let voiceChangerEngine: VoiceChangerEngine
    private let screenRecorder: ScreenRecorder
    
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
      
      // Gives 0.3 seconds buffer before presenting the audio capture permission dialog.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.handleVoiceCapturePermission()
      }
      
      // Observes the location of voice with the effect
      // applied, then display the share experience.
      voiceChangerEngine.$outputFileURL
        .compactMap { $0 }
        .sink { [weak self] audioFileURLWithEffect in
          
          guard let self = self else { return }
          
          guard case .manual = self.voiceChangerEngine.captureMode else { return }
          
          // Changing the status to "share" presents a dialog
          // to ask the user to share or reject the recorded spoken name.
          self.state = .share
          
          // Reset the capture voice using the sound analysis.
          self.voiceChangerEngine.captureMode = .auto
          
          self.logger.debug("✅ 🔊 Successully persisted the audio with effect at: \(audioFileURLWithEffect.absoluteString, privacy: .public)")
        }
        .store(in: &cancellables)
      
      // Updates the state on whether the audio contains `speech` or `silence`.
      voiceChangerEngine.$audioProcessingState
        .sink { [weak self] status in
          // On speech, the noun will move the mouth up & down.
          self?.isNounTalking = (status == .speech)
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
    
    // MARK: - Screen Recorder / Audio Effect
    
    func startVideoRecording<V, B>(source: V, background: B) where V: View, B: View {
      guard let recordedVoiceFileURL = voiceChangerEngine.outputFileURL else {
        return
      }
      
      screenRecorder.startRecording(
        source,
        backgroundView: background,
        audioFileURL: recordedVoiceFileURL
      )
    }
    
    @MainActor
    func stopVideoRecording() {
      Task {
        do {
          // The publisher will trigger the activity sharing sheet
          // with the url as an attachment.
          recordedTalkingNounVideoURL = try await screenRecorder.stopRecording()
          
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
