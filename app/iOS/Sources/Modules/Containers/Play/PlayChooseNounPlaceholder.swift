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
  
  /// A placeholder view for when there are no nouns to choose from in the Play (`NounPlayground`) experience.
  struct EmptyNounsView: View {
    
    let action: () -> Void

    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text(R.string.play.noNouns())
          .font(.custom(.bold, size: 36))
        
        Spacer()
        
        VStack(spacing: 0) {
          NounSpeechBubble(R.string.play.createNounSpeechBubble(), noun: "un-noun", spacing: -60)
          
          OutlineButton(
            text: R.string.play.createNoun(),
            largeAccessory: { Image.new },
            action: action)
            .controlSize(.large)
            .padding(.horizontal)
        }

        Spacer()
      }
    }
  }
}
