//
//  PlayTab.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-04.
//

import SwiftUI
import UIComponents
import Services
import SpriteKit

struct PlayTab: View {
  @State private var willMoveToNextScreen = false
  @Binding var isPresented: Bool
  
  private var scene: SKScene {
    let nounGameScene = NounGameScene(size: CGSize(width: 320, height: 320))
    nounGameScene.scaleMode = .fill
    return nounGameScene
  }
  
  var body: some View {
    NavigationView {
      VStack {
        SpeechBubble(R.string.play.subheadline())
          .font(.custom(.regular, size: 15))
          .padding(.horizontal, 20)
          .padding(.vertical, 0)
        
        ZStack {
          SpriteView(scene: scene, options: [.allowsTransparency])
            .frame(width: 320, height: 320)
        }
          .padding(.top, -40)
          .padding(.bottom, 40)
        
        NavigationLink(isActive: $willMoveToNextScreen) {
          PlayRecord(isPresented: $willMoveToNextScreen)
        } label: {
          EmptyView()
        }
        
        OutlineButton(text: R.string.play.proceedTitle(),
                      icon: { Image.playOutline },
                      action: { willMoveToNextScreen.toggle() })
          .controlSize(.large)
          .padding(.horizontal, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .softNavigationItems(leftAccessory: {
        SoftButton(
          icon: { Image.xmark },
          action: { isPresented.toggle() })
        
      }, rightAccessory: { EmptyView() })
      .background(Gradient.blueberryJam)
    }
  }
}
