//
//  OnChainNounProfileView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Profile view for showing noun details when selected from the explorer view
struct OnChainNounProfileView: View {
  @Binding var isPresented: Bool
  @State var isActivityPresented: Bool = false
  
  let auction: Auction
  
  private var noun: Noun {
    auction.noun
  }
  
  private var detailRows: some View {
    switch auction.settled {
    case true:
      return AnyView(SettledAuctionDetailRows(auction: auction, isActivityPresented: $isActivityPresented))
    case false:
      return AnyView(LiveAuctionDetailRows(auction: auction, isActivityPresented: $isActivityPresented))
    }
  }
  
  private var actionsRow: some View {
    HStack {
      SoftButton(
        text: "Share",
        largeAccessory: {
          Image.share
        },
        action: { },
        fill: [.width])
      
      SoftButton(
        text: "Remix",
        largeAccessory: {
          Image.splice
        },
        action: { },
        fill: [.width])
    }
  }
  
  private var nounIDLabel: some View {
    Text("Noun \(noun.id)")
      .font(.custom(.bold, relativeTo: .title2))
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      NounPuzzle(
        head: Image(nounTraitName: AppCore.shared.nounComposer.heads[noun.seed.head].assetImage),
        body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[noun.seed.body].assetImage),
        glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[noun.seed.glasses].assetImage),
        accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[noun.seed.accessory].assetImage)
      )
      
      PlainCell {
        VStack {
          HStack {
            nounIDLabel
            Spacer()
            
            SoftButton(icon: {
              Image.xmark
            }, action: {
              isPresented.toggle()
            })
          }
          
          detailRows
          .labelStyle(.titleAndIcon(spacing: 14))
          .padding(.bottom, 40)
          
          actionsRow
        }
      }
      .padding([.bottom, .horizontal])
    }
    .background(Gradient.warmGreydient)
    .sheet(isPresented: $isActivityPresented, onDismiss: nil) {
      
      NounderActivitiesView(
        isPresented: $isActivityPresented,
        noun: noun)
    }
  }
}

struct SettledAuctionDetailRows: View {
  let auction: Auction
  @Binding var isActivityPresented: Bool
  
  private var noun: Noun {
    auction.noun
  }
  
  private var ethPrice: String {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: auction.amount) ?? "N/A"
  }
  
  private var truncatedOwner: String {
    let leader = "..."
    let headCharactersCount = Int(ceil(Float(15 - leader.count) / 2.0))
    let tailCharactersCount = Int(floor(Float(15 - leader.count) / 2.0))
    
    return "\(noun.owner.id.prefix(headCharactersCount))\(leader)\(noun.owner.id.suffix(tailCharactersCount))"
  }
  
  private var formattedDate: String {
    guard let timeInterval = Double(auction.startTime) else { return "N/A" }
    
    let date = Date(timeIntervalSince1970: timeInterval)
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM dd YYYY"
    return dateFormatter.string(from: date)
  }
  
  private var birthdateRow: some View {
    InfoCell(text: "Born \(formattedDate)", icon: {
      Image.birthday
    })
  }
  
  private var bidWinnerRow: some View {
    InfoCell(text: "Won for", calloutText: ethPrice, icon: {
      Image.wonPrice
    }, calloutIcon: {
      Image.eth
    })
  }
  
  private var ownerRow: some View {
    InfoCell(text: "Held by", calloutText: truncatedOwner, icon: {
      Image.holder
    }, accessory: {
      Image.mdArrowRight
    })
  }
  
  private var activityRow: some View {
    InfoCell(text: "Activity", icon: {
      Image.history
    }, accessory: {
      Image.mdArrowRight
    }, tapAction: {
      isActivityPresented.toggle()
    })
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      birthdateRow
      bidWinnerRow
      ownerRow
      activityRow
    }
  }
}

struct LiveAuctionDetailRows: View {
  let auction: Auction
  @Binding var isActivityPresented: Bool
  
  private var noun: Noun {
    auction.noun
  }
  
  private func formattedDate(timeInterval: String) -> String {
    guard let timeInterval = Double(timeInterval) else { return "N/A" }
    
    let date = Date(timeIntervalSince1970: timeInterval)
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM dd YYYY"
    return dateFormatter.string(from: date)
  }
  
  private var ethPrice: String {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: auction.amount) ?? "N/A"
  }
  
  private var truncatedOwner: String {
    let leader = "..."
    let headCharactersCount = Int(ceil(Float(15 - leader.count) / 2.0))
    let tailCharactersCount = Int(floor(Float(15 - leader.count) / 2.0))
    
    return "\(noun.owner.id.prefix(headCharactersCount))\(leader)\(noun.owner.id.suffix(tailCharactersCount))"
  }
  
  private var nounIDLabel: some View {
    Text("Noun \(noun.id)")
      .font(.custom(.bold, relativeTo: .title2))
  }
  
  private var timeRemainingRow: some View {
    InfoCell(text: "Ends on", calloutText: formattedDate(timeInterval: auction.endTime), icon: {
      Image.timeleft
    })
  }
  
  private var birthdateRow: some View {
    InfoCell(text: "Born \(formattedDate(timeInterval: auction.startTime))", icon: {
      Image.birthday
    })
  }
  
  private var curretBidRow: some View {
    InfoCell(text: "Current bid", calloutText: ethPrice, icon: {
      Image.currentBid
    }, calloutIcon: {
      Image.eth
    })
  }
  
  private var activityRow: some View {
    InfoCell(text: "Bid history & activity", icon: {
      Image.history
    }, accessory: {
      Image.mdArrowRight
    }, tapAction: {
      isActivityPresented.toggle()
    })
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      timeRemainingRow
      birthdateRow
      curretBidRow
      activityRow
    }
  }
}
