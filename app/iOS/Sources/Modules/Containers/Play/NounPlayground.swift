//
//  NounPlayground.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-05.
//

import SwiftUI
import Services
import UIComponents
import Combine
import SpriteKit

struct NounPlayground: View {
  @StateObject var viewModel = ViewModel()
  
  @State private var selection: Int = 0
  @Environment(\.dismiss) private var dismiss
  @Namespace private var nsTypeSelection
  
  /// Holds a reference to the localized text.
  private let localize = R.string.nounPlayground.self
  
  /// A view that displays the noun scene above the various list of audio effect.
  ///
  /// - Returns: This view contains the play scene to animate the eyes and mouth.
  let talkingNoun = TalkingNoun()
  
  var body: some View {
    VStack(spacing: 0) {
      // Displays the current recoding state.
      Text(R.string.playExperience.playgroundTitle())
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(Color.componentNounsBlack)
      
      ConditionalSpacer(!viewModel.isRequestingAudioPermission)
      
      SpriteView(scene: talkingNoun, options: [.allowsTransparency])
        .frame(width: 320, height: 320)
      
      Spacer()
      
      // The maximum record duration is set to 20 seconds by default.
      RecordButton(
        $viewModel.isRecording,
        coachmark: localize.holdToRecordCoachmark()
      ).padding(.bottom, 60)
      
      OutlinePicker(selection: $selection) {
        ForEach(VoiceChangerEngine.Effect.allCases, id: \.rawValue) { effect in
          effect.image
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: nsTypeSelection)
        }
      }
      .padding(.bottom, 20)
      .hidden(viewModel.isRequestingAudioPermission)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationTitle(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { dismiss() })
    })
    .background(Gradient.bubbleGum)
    .bottomSheet(isPresented: viewModel.showAudioPermissionDialog) {
      // Presents the audio permission dialog on not determined
      // state of audio capture permission.
      AudioPermissionDialog(viewModel: viewModel)
    }
    .bottomSheet(isPresented: viewModel.showAudioSettingsSheet) {
      // Presents the audio settings dialog on denied
      // of the audio capture permission.
      AudioSettingsDialog(viewModel: viewModel)
    }
    .onDisappear {
      viewModel.stopListening()
    }
    .onChange(of: selection) { newValue in
      // Updates the recording on audio effect changes.
      viewModel.updateEffect(to: .init(rawValue: newValue) ?? .robot)
    }
    .onChange(of: viewModel.isNounTalking) { isNounTalking in
      // Moves up & down the mouth while playing back the audio recorded.
      talkingNoun.isTalking = isNounTalking
    }
  }
}
