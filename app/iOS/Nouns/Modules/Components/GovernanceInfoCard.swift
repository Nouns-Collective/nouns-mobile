// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

/// An informational card accessible from a settled noun's bid/activity feed
struct GovernanceInfoCard: View {
  @Binding var isPresented: Bool
  
  /// The id of the noun
  let nounId: String?
  
  /// The owner of the noun
  let owner: String?

  /// The page for which to show governance help information
  let page: AuctionInfo.Page?
  
  /// The ENS domain of the noun's owner
  @State private var domain: String?

  private let localize = R.string.nounDAOInfo.self

  private var websiteURL: URL? {
    if let nounId = nounId {
      return URL(string: R.string.shared.nounsProfileWebsite(nounId))
    }
    return URL(string: R.string.shared.nounsProposalsWebsite())
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack {
        Text(localize.title())
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

      if let nounId = nounId {
        Text(page == .activity ? localize.activityDescription(nounId) : localize.bidHistoryDescription(nounId))
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(5)
      } else {
        Text(R.string.proposal.message())
          .font(.custom(.regular, relativeTo: .subheadline))
          .lineSpacing(5)
      }
    }
    .padding()
    .padding(.bottom, 4)
    .task {
      if let owner = owner {
        do {
          self.domain = try await AppCore.shared.ensNameService.domainLookup(address: owner)
        } catch {}
      }
    }
  }
}
