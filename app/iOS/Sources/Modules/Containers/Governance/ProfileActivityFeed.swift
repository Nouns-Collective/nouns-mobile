//
//  ProfileActivityFeed.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

struct ProfileActivityFeed: View {
  let auction: Auction
  
  @EnvironmentObject private var store: AppStore
  
  private var activityState: ActivityState {
    store.state.activity
  }
  
  private var isEmpty: Bool {
    !activityState.isLoading && activityState.votes.isEmpty
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        Text(auction.noun.owner.id)
          .font(.custom(.bold, size: 36))
        
        ForEach(store.state.activity.votes, id: \.proposal.id) { vote in
          ActivityRow(vote: vote)
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity)
    .emptyPlaceholder(
      condition: isEmpty,
      message: R.string.activity.emptyState()
    )
    .activityIndicator(isPresented: activityState.isLoading)
    .onAppear {
      store.dispatch(FetchNounActivityAction(noun: auction.noun))
    }
  }
}

struct ActivityRow: View {
  let vote: Vote
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .center) {
          VoteChip(vote: vote)
          
          Spacer()
          
          Text(R.string.activity.proposalStatus(
            vote.proposal.id,
            vote.proposal.status.rawValue.capitalized))
            .foregroundColor(Color.componentNounsBlack)
            .font(Font.custom(.medium, relativeTo: .footnote))
            .opacity(0.5)
        }
        
        Text(vote.proposal.title ?? R.string.activity.proposalUntitled())
          .fontWeight(.semibold)
        
      }.padding()
    }
  }
}
