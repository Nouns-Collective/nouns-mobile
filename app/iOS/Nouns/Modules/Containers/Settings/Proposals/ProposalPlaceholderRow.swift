//
//  ProposalPlaceholderRow.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-21.
//

import SwiftUI
import NounsUI

/// A row cell to show as a placeholder for when proposals are loading
struct ProposalPlaceholderRow: View {
  
  var body: some View {
    
    PlainCell {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Proposal 00")
            .font(.custom(.regular, relativeTo: .caption))
            .redactable(style: .skeleton)
          
          Spacer()
          
          ChipLabel("Loading", state: .pending)
            .redactable(style: .gray)
            .clipShape(Capsule())
        }
        
        Text("Proposal Placeholder Title")
          .font(.custom(.medium, relativeTo: .subheadline))
          .redactable(style: .skeleton)
        
      }.padding()
    }
  }
}
