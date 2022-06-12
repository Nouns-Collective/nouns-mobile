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

import Foundation
import Services

extension OffChainNounProfile {
  
  final class ViewModel: ObservableObject {
    
    /// The current represented noun.
    @Published var noun: Noun
    
    /// A string indicate the noun birthday in long date style.
    @Published private(set) var nounBirthdate: String
    
    /// A boolean to present the playground with the use of the current noun.
    @Published var isPlayPresented: Bool = false
    
    @Published var isRenamePresented: Bool = false
    
    @Published var isDeletePresented: Bool = false
    
    @Published var isShareSheetPresented: Bool = false
    
    @Published var shouldShowNounCreator: Bool = false
    
    /// The image data of the noun to export and share
    @Published var exportImageData: Data?
        
    private let service: OffChainNounsService
    
    init(
      noun: Noun,
      service: OffChainNounsService = AppCore.shared.offChainNounsService
    ) {
      self.noun = noun
      self.service = service
      
      nounBirthdate = noun.createdAt.formatted(dateStyle: .long)
    }
    
    func deleteNoun() {
      do {
        try service.delete(noun: noun)
      } catch {
        print("Error: \(error)")
      }
    }
    
    private func saveChanges() {
      do {
        try service.store(noun: noun)
      } catch {
        print("Error: \(error)")
      }
    }
    
    func didEdit(seed: Seed) {
      noun.seed = seed
      saveChanges()
    }

    func didRename(_ name: String) {
      noun.name = name
      saveChanges()
    }

    func onShare() {
      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.shareOffchainNoun,
                                        parameters: ["noun_name": noun.name])
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.offchainNounProfile)
    }
  }
}
