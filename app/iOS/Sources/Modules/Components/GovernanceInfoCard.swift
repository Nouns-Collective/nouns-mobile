//
//  GovernanceInfoView.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import UIComponents

/// An informational card accessible from a settled noun's bid/activity feed
struct GovernanceInfoCard: View {
  @Binding var isPresented: Bool
  
  /// The id of the noun
  let nounId: String?
  
  /// The owner of the noun
  let owner: String?
  
  /// The ENS domain of the noun's owner
  @State private var domain: String?
  
  @State private var isSafariPresented = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Text(R.string.nounDAOInfo.title())
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        SoftButton(
          icon: { Image.xmark },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
      }
      
      if let nounId = nounId, let owner = owner {
        Text(R.string.nounDAOInfo.description(nounId, domain ?? owner))
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(5)
      } else {
        Text(R.string.nounDAOInfo.descriptionNoOwner())
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(5)
      }
      
      SoftButton(
        text: R.string.shared.learnMore(),
        smallAccessory: { Image.squareArrowDown },
        action: { isSafariPresented.toggle() })
        .controlSize(.large)
    }
    .padding()
    .padding(.bottom, 4)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = URL(string: R.string.shared.nounsWebsite()) {
        Safari(url: url)
      }
    }
    .task {
      if let owner = owner {
        do {
          self.domain = try await AppCore.shared.ensNameService.domainLookup(address: owner)
        } catch {}
      }
    }
  }
}
