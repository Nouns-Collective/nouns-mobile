//
//  NounProfileInfoCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import SwiftUI
import UIComponents
import Services

struct NounProfileInfoCard: View {
  let auction: Auction
  @State private var isActivityPresented = false
  @State private var isShareSheetPresented = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        NounPuzzle(seed: auction.noun.seed)
        
        PlainCell {
          NounProfileInfoCardNavigation(auction: auction)
          
          if auction.settled {
            SettledAuctionInfoCard(
              auction: auction,
              isActivityPresented: $isActivityPresented
            )
            
          } else {
            LiveAuctionInfoCard(
              auction: auction,
              isActivityPresented: $isActivityPresented
            )
          }
          
          NounProfileInfoCardItems(
            isShareSheetPresented: $isShareSheetPresented
          )
        }
        .padding([.bottom, .horizontal])
      }
      .background(Gradient.warmGreydient)
    }
    .sheet(isPresented: $isShareSheetPresented) {
      if let url = URL(string: "https://nouns.wtf/noun/\(auction.noun.id)") {
        ShareSheet(activityItems: [url])
      }
    }
  }
}

private struct NounProfileInfoCardNavigation: View {
  let auction: Auction
  
  var body: some View {
    HStack {
      Text(R.string.explore.noun(auction.noun.id))
        .font(.custom(.bold, relativeTo: .title2))
      
      Spacer()
      
      SoftButton(
        icon: { Image.xmark },
        action: { })
    }
  }
}

private struct NounProfileInfoCardItems: View {
  @Binding var isShareSheetPresented: Bool
  
  var body: some View {
    // Various available actions.
    HStack {
      // Shares the live auction link.
      SoftButton(
        text: R.string.shared.share(),
        largeAccessory: { Image.share },
        action: { isShareSheetPresented.toggle() },
        fill: [.width])
      
      // Switch context to the playground exprience using the current Noun's seed.
      SoftButton(
        text: R.string.shared.remix(),
        largeAccessory: { Image.splice },
        action: { },
        fill: [.width])
    }
  }
}
