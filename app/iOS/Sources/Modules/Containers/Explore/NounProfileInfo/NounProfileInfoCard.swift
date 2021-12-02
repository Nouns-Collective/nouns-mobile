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
  @State var isActivityPresented = false
  
  @Environment(\.openURL) private var openURL
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        Spacer()
        NounPuzzle(seed: auction.noun.seed)
        NounProfileInfoCardNavigation(auction: auction)
        
        if auction.settled {
          SettledAuctionInfoCard(auction: auction)
        } else {
          LiveAuctionInfoCard(auction: auction)
        }
        
        NounProfileInfoCardItems()
      }
      .background(Gradient.warmGreydient)
    }
//    .sheet(isPresented: $showShareSheet) {
//      if let url = URL(string: "https://nouns.wtf/noun/\(noun.id)") {
//        ShareSheet(activityItems: [url])
//      }
//    }
  }
}

struct NounProfileInfoCardNavigation: View {
  internal let auction: Auction
  @Environment(\.presentationMode) private var presentationMode
  
  var body: some View {
    HStack {
      Text(R.string.explore.noun(auction.noun.id))
        .font(.custom(.bold, relativeTo: .title2))
      
      Spacer()
      
      SoftButton(icon: { Image.xmark }, action: {
        presentationMode.wrappedValue.dismiss()
      })
    }
  }
}

struct NounProfileInfoCardItems: View {
  
  var body: some View {
    // Various available actions.
    HStack {
      // Shares the live auction link.
      SoftButton(
        text: R.string.shared.share(),
        largeAccessory: { Image.share },
        action: { /* showShareSheet.toggle() */ },
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
