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
  @State var isRecording = false
  
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = ViewModel()
  @Namespace private var nsTypeSelection
  
  private var playScene: PlayScene {
    let scene = PlayScene(size: CGSize(width: 320, height: 320))
    scene.scaleMode = .fill
    scene.view?.showsFPS = false
    return scene
  }
  
  var body: some View {
    let selectedEffect = Binding(
      get: { viewModel.currentEffect.rawValue },
      set: { viewModel.updateEffect(to: VoiceChangerEngine.Effect(rawValue: $0) ?? .alien) }
    )
    
    VStack(spacing: 50) {
      Text(R.string.play.playgroundTitle())
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(Color.componentNounsBlack)
      
      Spacer()
      
      SpriteView(scene: playScene, options: [.allowsTransparency])
        .frame(width: 320, height: 320)
      
      Spacer()
      
      OutlinePicker(selection: selectedEffect) {
        ForEach(viewModel.effects.indices, id: \.self) { index in
          viewModel.effects[index]
            .frame(width: 40)
            .pickerItemTag(index, namespace: nsTypeSelection)
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
    .onChange(of: viewModel.dismissPlayExperience) { newValue in
      guard newValue else { return }
      dismiss()
    }
  }
}
