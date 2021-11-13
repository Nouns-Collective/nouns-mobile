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
    case .for:
      return Label("Voted for", systemImage: "checkmark")
        .contained(textColor: .white, backgroundColor: Color.blue)
        .labelStyle(.titleAndIcon(spacing: 3))
        .font(.custom(.medium, relativeTo: .footnote))
    case .against:
      return Label("Vote Against", systemImage: "xmark")
        .contained(textColor: .white, backgroundColor: Color.red)
        .labelStyle(.titleAndIcon(spacing: 3))
        .font(.custom(.medium, relativeTo: .footnote))
    }
  }
  
  private var proposalStatusLabel: some View {
    Text("Proposal \(vote.proposal.id) • \(vote.proposal.status.rawValue.capitalized)")
      .font(Font.custom(.medium, relativeTo: .body))
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
