//
//  LiveAuctionCardErrorPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-17.
//

import SwiftUI
import NounsUI

extension ExploreExperience {
  
  struct LiveAuctionCardErrorPlaceholder: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(spacing: 0) {
        NounSpeechBubble(R.string.explore.liveError(), noun: "dead-noun")
        OutlineButton(text: R.string.shared.tryAgain(), largeAccessory: {
          Image.retry
        }, action: {
          Task {
            await viewModel.listenLiveAuctionChanges()
          }
        })
        .controlSize(.large)
      }
    }
  }
}
