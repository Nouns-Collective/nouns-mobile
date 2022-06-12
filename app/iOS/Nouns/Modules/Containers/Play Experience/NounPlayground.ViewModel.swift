// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
      
      ///
      case processing
      
      /// The user has completed recording and is ready to share, save, or start over
      case share
    }
    
    /// The current state of the playground where it switches between simply playing
    /// the voice with effect `freestyle`, adding the audio persistence
    /// option `recording`, or allowing the user to share it `share`.
    @Published private(set) var state: State = .freestyle
    
    /// Determines whether the user request to record and store audio on disk for sharing.
    @Published var isRecording = false {
      didSet {
        voiceChangerEngine.captureMode = .manual(isRecording)
        
        guard !isRecording else { return }
        
        // Changing the status to `processing` presents a dialog
        // to show the talking noun video processing progress.
        state = .processing
        playbackCapturedVoice()
      }
    }
    
    @Published private(set) var voiceRecordStateCoachmark: String
    
    /// Shows the audio permission sheet to request voice capture permission.
    @Published var showAudioCapturePermissionDialog = false
    
    /// Shows the audio settings sheet when the voice capture permission has been denied or restricted.
    @Published var showAudioCaptureSettingsSheet = false
    
    /// A Boolean value indicates whether the noun is talking.
    @Published private(set) var isNounTalking = false
    
    /// Represents recorded videos of the talking noun with version with and without watermark.
    @Published private(set) var recordedVideo: (preview: URL, share: URL)?
    
    ///
    @Published private(set) var videoPreparationProgress: Double = 0.0
    
    /// Represents the recorded voice playback status if on `speech` or `silent` mode.
    var audioProcessingState: AudioStatus {
      voiceChangerEngine.audioProcessingState
    }
    
    /// Represents the effect currently applied to the recorded voice.
    var currentVoiceEffect: VoiceChangerEngine.Effect {
      voiceChangerEngine.effect
    }
    
    /// A boolean to indicate audio capture permission dialog is presented.
    var isRequestingAudioCapturePermission: Bool {
      showAudioCaptureSettingsSheet || showAudioCapturePermissionDialog
    }
    
    /// The current displayed noun.
    let currentNoun: Noun
    
    /// A service to record and play captured voice with an effect applied.
    private let voiceChangerEngine: VoiceChangerEngine
    
    /// A service to record the spoken noun while playing to the captured voice.
    private let screenRecorder: ScreenRecorder
    
    /// Stores this type-erasing cancellable instance in the specified set.
    private var cancellables = Set<AnyCancellable>()
    
    /// Holds a reference to the localized text.
    private let localize = R.string.nounPlayground.self
    
    /// An object for writing interpolated string messages to the unified logging system.
    private let logger = Logger(
      subsystem: "wtf.nouns.ios",
      category: "Noun Playground"
    )
    
    init(
      noun: Noun,
      voiceChangerEngine: VoiceChangerEngine = VoiceChangerEngine(),
      screenRecorder: ScreenRecorder = CAScreenRecorder()
    ) {
      self.currentNoun = noun
      self.voiceChangerEngine = voiceChangerEngine
      self.screenRecorder = screenRecorder
      
      voiceRecordStateCoachmark = localize.voiceStateNotRecording()
      
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
          
          Task {
            // Gives a buffer of 1.0 seconds before presenting
            // the notification permission dialog.
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            await self.stopVideoRecording()
          }
          
          self.state = .share
          
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
      
      // Subscribes to the voice capture state to reflect the changes.
      voiceChangerEngine.$captureState.sink { [weak self] state in
        guard let self = self else { return }
        
        switch state {
        case .recording:
          // Update the coachmark on top to indicate the noun is talking.
          self.voiceRecordStateCoachmark = self.localize.voiceStateRecording()
          
        case .idle, .playing:
          // Update the coachmark on top to indicate the noun is not talking.
          self.voiceRecordStateCoachmark = self.localize.voiceStateNotRecording()
        }
      }
      .store(in: &cancellables)
    }
    
    deinit {
      stopListening()
    }
    
    func reset() {
      state = .freestyle
      
      // Reset the capture voice using the sound analysis.
      voiceChangerEngine.captureMode = .auto
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
        showAudioCapturePermissionDialog = true
        
      case .granted:
        showAudioCapturePermissionDialog = false
        startListening()
        
      case .denied, .restricted:
        showAudioCaptureSettingsSheet = true
      }
    }
    
    /// Asks the `VoiceChangerEngine` to start listening to audio using the microphone input.
    /// Recording is triggered depending on the selected `manual` or `auto` mode
    /// where the latter uses sound analysis to detect `speech` or `silence`.
    func startListening() {
      do {
        try voiceChangerEngine.prepare()
      } catch {
        logger.error("💥 🎙 Unable to prepare the voice changer engine: \(error.localizedDescription, privacy: .public)")
      }
    }
    
    /// Asks the `VoiceChangerEngine` to stop capturing audio.
    func stopListening() {
      voiceChangerEngine.stop()
    }
    
    /// Playback manuall the captured voice with the applied effect.
    func playbackCapturedVoice() {
      voiceChangerEngine.playback()
        .sink { _ in
          self.videoPreparationProgress = 1.0
          
        } receiveValue: { progress in
          self.videoPreparationProgress = progress
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Audio Effects
    
    /// Updates the currently selected effect
    func updateEffect(to effect: VoiceChangerEngine.Effect) {
      voiceChangerEngine.effect = effect
    }
    
    // MARK: - Talking Noun Video Recorder
    
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
          recordedVideo = try await screenRecorder.stopRecording()
          
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
