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
  let noun: Noun
  
  private var truncatedOwner: String {
    let leader = "..."
    let headCharactersCount = Int(ceil(Float(15 - leader.count) / 2.0))
    let tailCharactersCount = Int(floor(Float(15 - leader.count) / 2.0))
    
    return "\(noun.owner.id.prefix(headCharactersCount))\(leader)\(noun.owner.id.suffix(tailCharactersCount))"
  }
  
  private var titleLabel: some View {
    Text(truncatedOwner)
      .font(.custom(.bold, size: 36))
  }
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      if !store.state.activity.isLoading && store.state.activity.votes.isEmpty {
        Text(R.string.activity.emptyState())
          .font(.custom(.medium, relativeTo: .headline))
          .padding()
      } else {
        VStack(alignment: .leading, spacing: 10) {
          titleLabel
          
          ForEach(store.state.activity.votes, id: \.proposal.id) { vote in
            ActivityRowCell(vote: vote)
          }
        }
        .padding()
      }
    }
    .frame(maxWidth: .infinity)
    .activityIndicator(isPresented: store.state.activity.isLoading)
    .onAppear {
      store.dispatch(FetchNounActivityAction(noun: noun))
    }
  }
}

struct ActivityRowCell: View {
  let vote: Vote
  
  private var voteLabel: some View {
    switch vote.supportDetailed {
    case .abstain:
      return ChipLabel(R.string.activity.absent(), state: .neutral)
      
    case .for:
      return ChipLabel(R.string.activity.for(), state: .positive)
      
    case .against:
      return ChipLabel(R.string.activity.against(), state: .negative)
    }
  }
  
  private var proposalStatusLabel: some View {
    Text(R.string.activity.proposalStatus(vote.proposal.id, vote.proposal.status.rawValue.capitalized))
      .foregroundColor(Color.componentNounsBlack)
      .font(Font.custom(.medium, relativeTo: .footnote))
      .opacity(0.5)
  }
  
  private var descriptionLabel: some View {
    Text(vote.proposal.title ?? R.string.activity.proposalUntitled())
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
      }.padding()
    }
  }
}
