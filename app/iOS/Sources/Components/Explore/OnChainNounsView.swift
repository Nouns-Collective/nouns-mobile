//
//  OnChainNounsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Combine
import Services

struct OnChainNounsView: View {
  @EnvironmentObject var store: AppStore
  
  var animation: Namespace.ID
  @Binding var selected: Auction?
  @Binding var isPresentingActivity: Bool
  
  private var isInitiallyLoading: Bool {
    store.state.onChainAuctions.isLoading && store.state.onChainAuctions.auctions.isEmpty
  }
  
  let columns = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20)
  ]
  
  var body: some View {
    if isInitiallyLoading {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(0..<4) { _ in
          OnChainNounPlaceholderCard()
        }
      }
      .loading()
      .disabled(true)
    } else {
      PaginatingVGrid(store.state.onChainAuctions.auctions, isLoading: store.state.onChainAuctions.isLoading, content: { auction in
        OnChainNounCard(
          animation: animation,
          auction: auction)
          .id(auction.noun.id)
          .matchedGeometryEffect(id: "noun-\(auction.noun.id)", in: animation)
          .onTapGesture {
            withAnimation(.spring()) {
              selected = auction
            }
          }
      }, loadMoreAction: {
        store.dispatch(FetchOnChainAuctionsAction(after: $0))
      }, placeholderView: {
        ForEach(0..<2) { _ in
          OnChainNounPlaceholderCard()
            .loading()
        }
      })
    }
  }
}

struct Previews: PreviewProvider {
  @Namespace static var ns
  
  static var previews: some View {
    OnChainNounsView(animation: ns, selected: .constant(nil), isPresentingActivity: .constant(false))
  }
}
