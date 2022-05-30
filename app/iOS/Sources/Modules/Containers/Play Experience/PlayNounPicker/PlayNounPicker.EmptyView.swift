//
//  PlayChooseNounPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-09.
//

import SwiftUI
import UIComponents
import Services

extension PlayNounPicker {
    
  /// A placeholder view for when there are no nouns to choose
  /// from in the Play (`NounPlayground`) experience.
  struct EmptyView: View {
    
    ///
    let action: () -> Void
    
    ///
    @Environment(\.outlineTabViewHeight) private var tabBarHeight
    
    /// Holds a reference to the localized text.
    private let localize = R.string.playExperience.self
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text(R.string.playExperience.noNouns())
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        VStack(spacing: 0) {
          NounSpeechBubble(
            localize.createNounSpeechBubble(),
            noun: "un-noun", spacing: -60)
          
          OutlineButton(
            text: localize.createNoun(),
            largeAccessory: { Image.new },
            action: action)
            .controlSize(.large)
            .padding(.horizontal)
        }

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun
      // card and the top of the tab view
      .padding(.bottom, 20)
    }
  }
}
