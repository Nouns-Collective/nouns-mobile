//
//  ActivityRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 17.12.21.
//

import SwiftUI
import UIComponents

struct ActivityRow: View {
  let viewModel: ViewModel
  
  var body: some View {
    PlainCell {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .center) {
          VoteChip(vote: viewModel.vote)
          
          Spacer()
          
          Text(viewModel.proposalStatus)
            .foregroundColor(Color.componentNounsBlack)
            .font(Font.custom(.medium, relativeTo: .subheadline))
            .opacity(0.5)
        }
        
        Text(viewModel.proposalTitle)
          .fontWeight(.semibold)
        
      }.padding()
    }
  }
}
