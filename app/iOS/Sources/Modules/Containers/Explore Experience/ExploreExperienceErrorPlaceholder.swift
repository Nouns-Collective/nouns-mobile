//
//  ExploreExperienceErrorPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-18.
//

import SwiftUI
import UIComponents

extension ExploreExperience {
  
  /// An empty view to show when both the live auction and settled auctions fail to load (and the settled auctions array is empty)
  struct EmptyErrorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
      VStack(spacing: 0) {
        NounSpeechBubble(R.string.explore.allErrorEmpty(), noun: "dead-noun")
        OutlineButton(text: R.string.shared.tryAgain(), largeAccessory: {
          Image.retry
        }, action: {
          Task {
            await viewModel.listenLiveAuctionChanges()
            await viewModel.loadAuctions()
          }
        })
        .controlSize(.large)
      }
    }
  }
}
