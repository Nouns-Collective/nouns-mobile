//
//  PlayMissingNounView.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-04.
//

import SwiftUI
import UIComponents
import Services
import SpriteKit

/// A view to present if the user tries to access the noun playground but has created no offline nouns
/// This view presents a message and an action button to create a new noun
struct PlayMissingNounView: View {
  
  @State private var willMoveToNextScreen = false
  @Binding var isPresented: Bool

  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        
        NounSpeechBubble(R.string.play.createNounTitle(), noun: "un-noun")
          .font(.custom(.regular, size: 15))
          .padding(.horizontal, 20)

        NavigationLink(isActive: $willMoveToNextScreen) {
          NounCreator()
        } label: {
          EmptyView()
        }
        
        OutlineButton(text: R.string.play.createNoun(),
                      largeAccessory: { Image.new },
                      action: { willMoveToNextScreen.toggle() })
          .controlSize(.large)
          .padding(.horizontal, 20)
        
        Spacer()
      }
      .offset(x: 0, y: -60)
      .padding()
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

struct PlayMissingNounViewPreview: PreviewProvider {
  static var previews: some View {
    PlayMissingNounView(isPresented: .constant(true))
  }
}
