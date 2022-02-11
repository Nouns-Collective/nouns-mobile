//
//  PlayExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import Services

struct PlayExperience: View {
  @Environment(\.outlineTabViewHeight) var tabBarHeight
  @State private var isNounPickerPresented = false
  
  @StateObject private var viewModel = ViewModel()
    
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.play.subheadline())
          .font(.custom(.regular, size: 17))
        
        VStack(spacing: 0) {
          VStack(spacing: -40) {
            SpeechBubble(R.string.play.speechBubble())
            
            Image(R.image.pizzaNoun.name)
              .resizable()
              .scaledToFit()
          }
        
          // Navigation link showing the noun selection to choose from
          Link(isActive: $isNounPickerPresented, content: {
            OutlineButton(
              text: R.string.play.proceedTitle(),
              largeAccessory: { Image.fingergunsRight },
              action: { isNounPickerPresented.toggle() })
              .controlSize(.large)
            
          }, destination: {
            PlayNounPicker()
          })
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun
      // card and the top of the tab view.
      .padding(.bottom, 20)
      .softNavigationTitle(R.string.play.title())
      .background(Gradient.blueberryJam)
      .ignoresSafeArea(edges: .top)
    }
  }
}
