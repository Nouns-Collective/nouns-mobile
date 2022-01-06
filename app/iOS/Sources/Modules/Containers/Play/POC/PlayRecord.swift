//
//  PlayRecord.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-05.
//

import SwiftUI
import Services
import UIComponents
import Combine
import SpriteKit

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

let nounGameScene = NounGameScene(size: CGSize(width: 320, height: 320))

struct PlayRecord: View {
  
  @Namespace var animation
  @Namespace private var typeSelectionNamespace

  @Binding var isPresented: Bool
  @State var isRecording: Bool = false
  
  @StateObject private var viewModel = ViewModel()
  
  var subscriptions = Set<AnyCancellable>()
  
  var scene: SKScene {
    nounGameScene.scaleMode = .fill
    return nounGameScene
  }
  
  var body: some View {
    let selectedEffect = Binding(
      get: { viewModel.selectedEffect.rawValue },
      set: { viewModel.updateEffect(to: AudioService.AudioEffect(rawValue: $0) ?? .alien) }
    )
    
    VStack(spacing: 50) {
      
      Spacer()
      
      ZStack {
        SpriteView(scene: scene, options: [.allowsTransparency])
          .frame(width: 400, height: 400)
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
        icon: { Image.back },
        action: { isPresented.toggle() })
      
    }, rightAccessory: { EmptyView() })
    .background(Gradient.bubbleGum)
    .onAppear {
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
