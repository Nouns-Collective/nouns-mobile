//
//  BidHistoryView.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI
import UIComponents
import Services

struct ProfileBidHistory: View {
  let auction: Auction
  
  @EnvironmentObject private var store: AppStore
  
  private var bidState: BidState {
    store.state.bid
  }
  
  private var isEmpty: Bool {
    !bidState.isLoading && bidState.bids.isEmpty
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        Text(R.string.explore.noun(auction.noun.id))
          .font(.custom(.bold, size: 36))
        
        ForEach(store.state.bid.bids, id: \.id) { bid in
          BidRow(bid: bid)
        }
      }
      .padding()
      .ignoresSafeArea()
    }
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    .emptyPlaceholder(
      condition: isEmpty,
      message: R.string.bidHistory.emptyState()
    )
    .activityIndicator(isPresented: store.state.activity.isLoading)
    .onAppear {
      store.dispatch(FetchBidHistoryAction(auction: auction))
    }
  }
}

struct BidRow: View {
  let bid: Bid
  
  private var blockDate: String {
    guard let timeInterval = Double(bid.blockTimestamp) else {
      return R.string.bidHistory.blockUnavailable()
    }
    
    let date = Date(timeIntervalSince1970: timeInterval)
    return DateFormatter.string(from: date, timeStyle: .short)
  }
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .center) {
          // Bid amount
          Label {
            Text(EtherFormatter.eth(from: bid.amount) ?? R.string.shared.unavailable())
              .foregroundColor(Color.componentNounsBlack)
              .font(.custom(.bold, relativeTo: .title3))
          } icon: {
            Image.eth
              .asThumbnail()
          }
          .labelStyle(.titleAndIcon(spacing: 4))
          
          Spacer()
          
          // Timestamp of the bid
          Text(blockDate)
            .font(Font.custom(.medium, relativeTo: .footnote))
            .opacity(0.5)
        }
        
        // An Account is any address that holds any amount of Nouns
        Label {
          Text(bid.bidder.id)
            .foregroundColor(Color.componentNounsBlack)
            .font(.custom(.medium, relativeTo: .subheadline))
            .truncationMode(.middle)
          
        } icon: {
          // Token avatar
          Image(R.image.placeholderEns.name)
            .asThumbnail()
            .clipShape(Circle())
        }
        
      }.padding()
    }
  }
}
