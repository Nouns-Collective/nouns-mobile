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
  @Namespace private var typeSelectionNamespace
  
  var nounPlayScene: PlayScene {
    let scene = PlayScene(viewModel: viewModel, size: CGSize(width: 320, height: 320))
    scene.scaleMode = .fill
    scene.view?.showsFPS = false
    return scene
  }
  
  var body: some View {
    let selectedEffect = Binding(
      get: { viewModel.selectedEffect.rawValue },
      set: { viewModel.updateEffect(to: VoiceChangerEffect(rawValue: $0) ?? .alien) }
    )
    
    VStack(spacing: 50) {
      Text(R.string.play.playgroundTitle())
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(Color.componentNounsBlack)
      
      Spacer()
      
      SpriteView(scene: nounPlayScene, options: [.allowsTransparency])
        .frame(width: 320, height: 320)
      
      Spacer()
      
      OutlinePicker(selection: selectedEffect) {
        ForEach(VoiceChangerEffect.allCases, id: \.self) { effect in
          effect.icon
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: typeSelectionNamespace)
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
  }
}
