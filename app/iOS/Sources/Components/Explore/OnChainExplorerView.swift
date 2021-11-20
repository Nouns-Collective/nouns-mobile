//
//  OnChainExplorerView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Housing view for exploring on chain nouns, including the current on-goign auction and previously auctioned nouns
struct OnChainExplorerView: View {
  @EnvironmentObject var store: AppStore
  
  @Namespace private var animation
  @State private var selectedAuction: Auction?
  @State private var isNounProfilePresented = false
  @State private var isPresentingNounActivity = false
  @State private var isPresentingAbout = false
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  private var isInitiallyLoading: Bool {
    (store.state.onChainAuctions.isLoading || store.state.liveAuction.isLoading) &&
    store.state.onChainAuctions.auctions.isEmpty
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          if let auction = store.state.liveAuction.auction {
            LiveAuctionCard(auction: auction)
              .onTapGesture {
                selectedAuction = auction
              }
          } else {
            LiveAuctionPlaceholderCard()
              .loading()
          }
          
          OnChainNounsView(
            animation: animation,
            selected: $selectedAuction,
            isPresentingActivity: $isPresentingNounActivity)
        }
        .padding(.horizontal, 20)
        .softNavigationTitle("Explore", rightAccessory: {
          SoftButton(
            text: "About",
            largeAccessory: { Image.about },
            action: {
              isPresentingAbout.toggle()
            })
        })
      }
      .disabled(isInitiallyLoading)
      .background(Gradient.lemonDrop)
      .ignoresSafeArea()
    }
    .onChange(of: selectedAuction) { newValue in
      isNounProfilePresented = newValue != nil
    }
    .onAppear {
      store.dispatch(FetchOnChainAuctionsAction())
      store.dispatch(ListenLiveAuctionAction())
    }
    /// Presents selected Noun's profile.
    .fullScreenCover(
      isPresented: $isNounProfilePresented,
      onDismiss: {
        selectedAuction = nil
      },
      content: {
        if let selectedAuction = selectedAuction {
          OnChainNounProfileView(
            isPresented: $isNounProfilePresented,
            auction: selectedAuction
          )
        }
      })
    /// Presents about Nouns.wtf
    .fullScreenCover(isPresented: $isPresentingAbout) {
      AboutNounsWTF(isPresented: $isPresentingAbout)
    }
  }
}

struct OnChainExplorerView_Previews: PreviewProvider {
  static var previews: some View {
    OnChainExplorerView()
  }
}
