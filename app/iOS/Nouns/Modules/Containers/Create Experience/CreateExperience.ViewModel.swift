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

import Foundation
import Services

extension CreateExperience {
  
  final class ViewModel: ObservableObject {
    
    /// A binding boolean value to determine if the noun creator should be presented
    @Published var isCreatorPresented = false

    /// The noun profile that is currently presented
    @Published var selectedNoun: Noun?
    
    /// The initial seed to show on the create experience tab as well as when creating a new noun
    @Published var initialSeed: Seed = AppCore.shared.nounComposer.randomSeed()
    
    func randomizeNoun() {
      initialSeed = AppCore.shared.nounComposer.randomSeed()
    }

    func onAppear() {
      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.create)
    }
  }
}
