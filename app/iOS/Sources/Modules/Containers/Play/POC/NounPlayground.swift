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
      
      Spacer()
      
      if let noun = viewModel.nouns.first {
        NounPuzzle(seed: noun.seed)
          .padding()
      }
     
      Spacer()
      
      OutlinePicker(selection: selectedEffect) {
        ForEach(AudioService.AudioEffect.allCases, id: \.self) { effect in
          effect.icon
            .frame(width: 40)
            .pickerItemTag(effect.rawValue, namespace: typeSelectionNamespace)
        }
      }
      .padding(.bottom, 100)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .softNavigationItems(leftAccessory: {
      SoftButton(
        icon: { Image.xmark },
        action: { isPresented.toggle() })
      
    }, rightAccessory: { EmptyView() })
    .background(Gradient.bubbleGum)
    .onAppear {
      // Fetch the off chain nouns the user has created
      viewModel.fetchOffChainNouns()
      
      // Request permission to use microphone
      viewModel.requestMicrophonePermission { success, error in
        if success {
          viewModel.startListening()
        } else {
          if let error = error {
            print("Error: \(error)")
          }
        }
      }
    }
    .onDisappear {
      viewModel.stopListening()
    }
  }
}
