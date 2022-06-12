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

extension OffChainNounsFeed {
  
  @MainActor
  final class ViewModel: ObservableObject {
    @Published var nouns = [Noun]()
    @Published var isFetching = false
    
    private let offChainNounsService: OffChainNounsService
    
    init(offChainNounsService: OffChainNounsService = AppCore.shared.offChainNounsService) {
      self.offChainNounsService = offChainNounsService
    }
    
    func fetchOffChainNouns() async {
      // when
      do {
        for try await nouns in offChainNounsService.nounsStoreDidChange(ascendingOrder: false) {
          self.nouns = nouns
        }
      } catch {
        print("Error: \(error)")
      }
    }
  }
}
