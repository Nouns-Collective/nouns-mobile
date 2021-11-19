//
//  NounderActivitiesView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

struct NounderActivitiesView: View {
  @EnvironmentObject var store: AppStore
  @Binding var isPresented: Bool
  
  let noun: Noun
  
  private var titleLabel: some View {
    Text("Activity")
      .font(.custom(.bold, relativeTo: .title))
  }
  
  private var domainLabel: some View {
    Text("bob.eth")
      .font(.custom(.regular, relativeTo: .subheadline))
      .opacity(0.75)
      .padding(.bottom, 40)
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      if !store.state.activities.isLoading && store.state.activities.votes.isEmpty {
        Text("No activities registered.")
          .font(.custom(.medium, relativeTo: .headline))
        
      } else {
        VStack(alignment: .leading) {
          titleLabel
          domainLabel
          
          ForEach(store.state.activities.votes, id: \.proposal.id) { vote in
            ActivityRowView(vote: vote)
          }
        }
        .padding()
        .padding(.top, 20)
      }
    }
    .activityIndicator(isPresented: store.state.activities.isLoading)
    .background(Gradient.warmGreydient)
    .onAppear {
      store.dispatch(FetchOnChainNounActivitiesAction(noun: noun))
    }
  }
}

struct ActivityRowView: View {
  let vote: Vote
  
  private var voteLabel: some View {
    switch vote.supportDetailed {
    case .abstain:
      return Label("Absent for", systemImage: "nosign")
        .contained(textColor: .white, backgroundColor: Color.gray.opacity(0.5))
        .labelStyle(.titleAndIcon(spacing: 3))
        .font(.custom(.medium, relativeTo: .footnote))
        .foregroundColor(Color.componentNounsBlack)
    case .for:
      return Label("Voted for", systemImage: "checkmark")
        .contained(textColor: .white, backgroundColor: Color.blue)
        .labelStyle(.titleAndIcon(spacing: 3))
        .font(.custom(.medium, relativeTo: .footnote))
        .foregroundColor(Color.componentNounsBlack)
    case .against:
      return Label("Vote Against", systemImage: "xmark")
        .contained(textColor: .white, backgroundColor: Color.red)
        .labelStyle(.titleAndIcon(spacing: 3))
        .font(.custom(.medium, relativeTo: .footnote))
        .foregroundColor(Color.componentNounsBlack)
    }
  }
  
  private var proposalStatusLabel: some View {
    Text("Proposal \(vote.proposal.id) • \(vote.proposal.status.rawValue.capitalized)")
      .foregroundColor(Color.componentNounsBlack)
      .font(Font.custom(.medium, relativeTo: .footnote))
      .opacity(0.5)
  }
  
  private var descriptionLabel: some View {
    Text(vote.proposal.title ?? "Untitled")
      .fontWeight(.semibold)
  }
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .center) {
          voteLabel
          Spacer()
          proposalStatusLabel
        }
        
        descriptionLabel
      }
    }
  }
}

struct BidRowView: View {
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
    }.labelStyle(.titleAndIcon(spacing: 4))
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
