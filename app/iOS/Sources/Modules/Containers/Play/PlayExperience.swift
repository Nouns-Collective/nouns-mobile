//
//  PlayExperience.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import SpriteKit

struct PlayExperience: View {
  @StateObject var viewModel: ViewModel 
  
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  @State private var isPlayPresented = false
  
  /// A view that displays the talking noun scene below the speech bubble.
  ///
  /// - Returns: This view contains the play scene to animate the eyes and mouth.
  private let talkingNoun: TalkingNoun
  
  init(viewModel: ViewModel = ViewModel()) {
    _viewModel = StateObject(wrappedValue: viewModel)
    talkingNoun = TalkingNoun(seed: viewModel.seed)
  }
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.playExperience.subheadline())
          .font(.custom(.regular, size: 17))
        
        VStack(spacing: 0) {
          VStack(spacing: -40) {
            SpeechBubble(R.string.playExperience.speechBubble())
            
            SpriteView(scene: talkingNoun, options: [.allowsTransparency])
              .frame(width: 320, height: 320)
          }
          
          OutlineButton(
            text: R.string.playExperience.proceedTitle(),
            largeAccessory: { Image.fingergunsRight },
            action: { isPlayPresented.toggle() })
            .controlSize(.large)
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
      .softNavigationTitle(R.string.playExperience.title())
      .background(Gradient.blueberryJam)
      .ignoresSafeArea(edges: .top)
      .fullScreenCover(isPresented: $isPlayPresented) {
        NounPlayground()
      }
    }
  }
}
