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
  
  @Namespace var animation
  @Namespace private var typeSelectionNamespace

  @Binding var isPresented: Bool
  @State var isRecording: Bool = false
  
  @StateObject private var viewModel = ViewModel()
  
  var subscriptions = Set<AnyCancellable>()
  
  var body: some View {
    let selectedEffect = Binding(
      get: { viewModel.selectedEffect.rawValue },
      set: { viewModel.updateEffect(to: AudioService.AudioEffect(rawValue: $0) ?? .alien) }
    )
    
    VStack(spacing: 50) {
      Text(R.string.play.playgroundTitle())
        .font(.custom(.bold, size: 19))
        .offset(y: -80)
        .foregroundColor(Color.componentNounsBlack)
      
      Spacer()
      
      if let noun = viewModel.nouns.first {
        NounPuzzle(seed: noun.seed)
          .padding()
          .offset(y: -70)
      }
     
      Spacer()
      
      OutlinePicker(selection: selectedEffect) {
        ForEach(AudioService.AudioEffect.allCases, id: \.self) { effect in
          effect.icon
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: typeSelectionNamespace)
        }
      }
      .padding(.bottom, 20)
      .emptyPlaceholder(when: viewModel.state == .coachmark) {
        CoachmarkTool(R.string.play.chooseCoachmark(), iconView: {
          Image.pointRight.white
            .rotationEffect(.degrees(-75))
        })
          .padding(.bottom, 60)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { isPresented.toggle() })
      
    }, rightAccessory: { EmptyView() })
    .background(Gradient.bubbleGum)
    .bottomSheet(isPresented: viewModel.showAudioPermissionDialog, content: {
      AudioPermissionDialog(viewModel: viewModel)
    })
    .onAppear {
      // Fetch the off chain nouns the user has created
      viewModel.fetchOffChainNouns()
      
      // Remove coachmark tool after some time
      if viewModel.state == .coachmark {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          withAnimation {
            viewModel.updateState(to: .freestyle)
          }
        }
      }
    }
    .onDisappear {
      viewModel.stopListening()
    }
  }
}
