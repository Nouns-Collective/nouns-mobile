// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
import Services

/// Loads the decentralised name for a given token.
struct ENSText: View {
  @State private var domain: String?
  
  private let ensService: ENS
  private let token: String
  
  init(
    token: String,
    ensService: ENS = AppCore.shared.ensNameService
  ) {
    self.token = token
    self.ensService = ensService
  }
  
  init(
    noun: Noun,
    ensService: ENS = AppCore.shared.ensNameService
  ) {
    self.token = noun.isNounderOwned ? R.string.nounProfile.noundersEth() : noun.owner.id
    self.ensService = ensService
  }
  
  var body: some View {
    Text(domain ?? token)
      .lineLimit(1)
      .truncationMode(.middle)
      .task {
        await fetchENS()
      }
  }
  
  @MainActor
  private func fetchENS() async {
    do {
      domain = try await ensService.domainLookup(address: token)
    } catch { }
  }
}
