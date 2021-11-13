//
//  NounderActivitiesView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

struct NounderActivitiesView: View {
  @Binding var isPresented: Bool
  internal let domain: String
  
  private var titleLabel: some View {
    Text("Activity")
      .font(.custom(.bold, relativeTo: .title))
  }
  
  private var domainLabel: some View {
    Text(domain)
      .font(.custom(.regular, relativeTo: .subheadline))
      .opacity(0.75)
      .padding(.bottom, 40)
  }
               
  var body: some View {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          titleLabel
          domainLabel
          
          ForEach(0..<5) { _ in
            ActivityRowView()
          }
        }
        .padding()
        .padding(.top, 20)
      }
      .background(Gradient.warmGreydient)
  }
}

struct ActivityRowView: View {
  
  private var voteLabel: some View {
    Label("Approved", systemImage: "checkmark")
      .contained(textColor: .white, backgroundColor: Color.blue)
      .labelStyle(.titleAndIcon(spacing: 3))
      .font(.custom(.medium, relativeTo: .footnote))
  }
  
  private var proposalStatusLabel: some View {
    Text("Proposal 14 • Passed")
      .font(Font.custom(.medium, relativeTo: .body))
      .opacity(0.5)
  }
  
  private var descriptionLabel: some View {
    Text("Brave Sponsored Takeover during NFT NYC")
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

struct NounderActivitiesSheet_Previews: PreviewProvider {
  static var previews: some View {
    NounderActivitiesView(isPresented: .constant(true), domain: "bob.eth")
  }
}
