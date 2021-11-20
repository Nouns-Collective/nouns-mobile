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
  var body: some View {
    Text("Bids History List")
  }
}

// MARK: Bid

struct BidRowCell: View {
  let bid: Bid
  
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
      Text(bid.bidder.id)
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
    return formatter.string(from: bid.amount) ?? "Unavailable"
  }
  
  private var formattedDate: String {
    guard let timeInterval = Double(bid.blockTimestamp) else { return "Unavailable" }
    
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
    
    return "\(dateString) at \(timeString)"
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
      }
    }
  }
}
