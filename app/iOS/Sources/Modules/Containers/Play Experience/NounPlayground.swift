//
//  NounPlayground.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-05.
//

import SwiftUI
import UIComponents
import SpriteKit
import Services

struct NounPlayground: View {
  @StateObject var viewModel: ViewModel
  
  @State private var selectedVoiceEffect: Int = 0
  @Environment(\.dismiss) private var dismiss
  @Namespace private var nsTypeSelection
  
  /// A boolean indicates whether the activity sharing sheet is presented.
  @State private var isShareSheetPresented = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.nounPlayground.self
  
  ///
  init(viewModel: ViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    talkingNoun = TalkingNoun(seed: viewModel.currentNoun.seed)
  }
  
  /// A view that displays the noun scene above the various list of audio effect.
  ///
  /// - Returns: This view contains the play scene to animate the eyes and mouth.
  private let talkingNoun: TalkingNoun
  
  /// A SwiftUI view that renders the `TalkingNoun` scene.
  private var spriteView: some View {
    SpriteView(scene: talkingNoun, options: [.allowsTransparency])
      .frame(width: 320, height: 320)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      // Displays the current voice recoding state.
      Text(viewModel.voiceRecordStateCoachmark)
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(.componentNounsBlack)
      
      ConditionalSpacer(!viewModel.isRequestingAudioCapturePermission)
      
      spriteView
      
      Spacer()
      
      // The maximum record duration is set to 20 seconds by default.
      RecordButton(
        $viewModel.isRecording,
        coachmark: localize.holdToRecordCoachmark()
      ).padding(.bottom, 60)
      
      OutlinePicker(selection: $selectedVoiceEffect) {
        ForEach(VoiceChangerEngine.Effect.allCases, id: \.rawValue) { effect in
          effect.image
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: nsTypeSelection)
        }
      }
      .padding(.bottom, 20)
      .hidden(viewModel.isRequestingAudioCapturePermission)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationTitle(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { dismiss() })
    })
    .background(Gradient.bubbleGum)
    // Presents the audio permission dialog on not determined
    // state of audio capture permission.
    .bottomSheet(isPresented: viewModel.showAudioCapturePermissionDialog) {
      AudioPermissionDialog(viewModel: viewModel)
    }
    // Presents the audio settings dialog on denied
    // of the audio capture permission.
    .bottomSheet(isPresented: viewModel.showAudioCaptureSettingsSheet) {
      AudioSettingsDialog(viewModel: viewModel)
    }
    .onDisappear {
      viewModel.stopListening()
    }
    // Updates the recording on audio effect changes.
    .onChange(of: selectedVoiceEffect) { newValue in
      viewModel.updateEffect(to: .init(rawValue: newValue) ?? .robot)
    }
    // Moves up & down the mouth while playing back the audio recorded.
    .onChange(of: viewModel.isNounTalking) { isNounTalking in
      talkingNoun.isTalking = isNounTalking
    }
//    .onChange(of: viewModel.state == .processing) { _ in
//      viewModel.startVideoRecording(
//        source: spriteView,
//        background: Gradient.bubbleGum
//      )
//    }
    .bottomSheet(isPresented: viewModel.state == .share, showDimmingView: false) {
      ShareTalkingNounDialog(
        videoURL: viewModel.recordedVideo?.share,
        progressValue: viewModel.videoPreparationProgress,
        reset: { viewModel.reset() }
      )
    }
  }
}
