//
//  BidHistoryView.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounderBidsHistoryView: View {
  @EnvironmentObject var store: AppStore
  let noun: Noun
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      if !store.state.bids.isLoading && store.state.bids.bids.isEmpty {
        Text(R.string.bidHistory.emptyState())
          .font(.custom(.medium, relativeTo: .headline))
          .padding()
      } else {
        VStack(alignment: .leading, spacing: 10) {
          Text(R.string.explore.noun(noun.id))
            .font(.custom(.bold, size: 36))
          
          ForEach(store.state.bids.bids, id: \.id) { bid in
            BidRowCell(bid: bid)
          }
        }
        .padding()
        .ignoresSafeArea()
      }
    }
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    .activityIndicator(isPresented: store.state.activities.isLoading)
    .onAppear {
      store.dispatch(FetchBidHistoryAction(noun: noun))
    }
  }
}

// MARK: Bid

struct BidRowCell: View {
  let bid: Bid
  
  private var truncatedBidder: String {
    let leader = "..."
    let headCharactersCount = Int(ceil(Float(15 - leader.count) / 2.0))
    let tailCharactersCount = Int(floor(Float(15 - leader.count) / 2.0))
    
    return "\(bid.bidder.id.prefix(headCharactersCount))\(leader)\(bid.bidder.id.suffix(tailCharactersCount))"
  }
  
  private var bidAmountLabel: some View {
    Label {
      Text(ethValue)
        .foregroundColor(Color.componentNounsBlack)
        .font(.custom(.bold, relativeTo: .title3))
    } icon: {
      Image.eth
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 20, alignment: .center)
    }
    .labelStyle(.titleAndIcon(spacing: 4))
  }
  
  private var dateLabel: some View {
    Text(formattedDate)
      .font(Font.custom(.medium, relativeTo: .footnote))
      .opacity(0.5)
  }
  
  private var bidderLabel: some View {
    Label {
      Text(truncatedBidder)
        .foregroundColor(Color.componentNounsBlack)
        .font(.custom(.medium, relativeTo: .subheadline))
    } icon: {
      Image(R.image.placeholderEns.name)
        .frame(width: 20, height: 20, alignment: .center)
        .clipShape(Circle())
    }
  }

  private var ethValue: String {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: bid.amount) ?? R.string.shared.unavailable()
  }
  
  private var formattedDate: String {
    guard let timeInterval = Double(bid.blockTimestamp) else {
      return R.string.bidHistory.blockUnavailable()
    }
    
    let date = Date(timeIntervalSince1970: timeInterval)
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM dd"
    let dateString = dateFormatter.string(from: date)
    
    let timeFormatter = DateFormatter()
    timeFormatter.timeZone = TimeZone.current
    timeFormatter.locale = NSLocale.current
    timeFormatter.dateFormat = "hh:mm a"
    let timeString = timeFormatter.string(from: date).lowercased()
    
    return R.string.bidHistory.blockDate(dateString, timeString)
  }
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .center) {
          bidAmountLabel

          Spacer()
          dateLabel
        }
        
        bidderLabel
      }.padding()
    }
  }
}
