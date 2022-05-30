//
//  ProposalRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import UIComponents
import Services

/// Provides Proposal info.
struct ProposalRow: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isDescriptionPresented = false
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text(viewModel.identifier)
            .font(.custom(.regular, relativeTo: .caption))
          
          Spacer()
          
          ProposalStatusChip(proposal: viewModel.proposal)
        }
        
        Text(viewModel.title)
          .font(.custom(.medium, relativeTo: .subheadline))
        
      }.padding()
    }
    .onTapGesture {
      viewModel.onPresent()
      isDescriptionPresented.toggle()
    }
    .fullScreenCover(isPresented: $isDescriptionPresented) {
      if let url = viewModel.proposalURL {
        Safari(url: url)
      }
    }
  }
}
