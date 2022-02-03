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
  
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = ViewModel()
  @Namespace private var nsTypeSelection
  
  @State private var selection: Int = 0
  
  private var playScene: PlayScene {
    let scene = PlayScene(viewModel: viewModel, size: CGSize(width: 320, height: 320))
    scene.scaleMode = .fill
    scene.view?.showsFPS = false
    return scene
  }
  
  private var spriteView: some View {
    SpriteView(scene: playScene, options: [.allowsTransparency])
      .frame(width: 320, height: 320)
  }
  
  var body: some View {
    VStack(spacing: 50) {
      Text(R.string.play.playgroundTitle())
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(Color.componentNounsBlack)
      
      Spacer()
      
      spriteView
      
      Spacer()
      
      // Record button should go here
      
      OutlinePicker(selection: $selection) {
        ForEach(VoiceChangerEngine.Effect.allCases, id: \.rawValue) { effect in
          effect.image
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: nsTypeSelection)
        }
      }
      .padding(.bottom, 20)
      //      .emptyPlaceholder(when: viewModel.state == .coachmark) {
      //        CoachmarkTool(R.string.play.chooseCoachmark(), iconView: {
      //          Image.pointRight.white
      //            .rotationEffect(.degrees(-75))
      //        })
      //          .padding(.bottom, 60)
      //      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { dismiss() })
      
    }, rightAccessory: { EmptyView() })
    .background(Gradient.bubbleGum)
    .bottomSheet(isPresented: viewModel.showAudioPermissionDialog, content: {
      AudioPermissionDialog(viewModel: viewModel)
    })
    .onDisappear {
      viewModel.stopListening()
    }
    .onChange(of: viewModel.dismissPlayExperience) { newValue in
      guard newValue else { return }
      dismiss()
    }
    .onChange(of: selection) { newValue in
      viewModel.updateEffect(to: .init(rawValue: newValue) ?? .robot)
    }
    .onChange(of: viewModel.isRecording) { recording in
      switch recording {
      case true:
        // viewModel.screenRecorder.startRecording(viewToRecord)
        break
      case false:
        viewModel.stopRecording()
      }
    }
  }
}
