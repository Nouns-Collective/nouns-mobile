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
import NounsUI
import Services

extension CreateExperience {
  
  /// A placeholder view for the Create tab for when the user has no created nouns
  struct EmptyNounsView: View {
    
    @Environment(\.outlineTabViewHeight) private var tabBarHeight
    
    @State private var seed: Seed = .default
    
    @State private var shouldShowAllTraits: Bool = false

    private let initialSeed: Seed
    
    private let action: () -> Void
    
    @Binding var isCreatorPresented: Bool
        
    init(
      initialSeed: Seed = Seed.default,
      isCreatorPresented: Binding<Bool>,
      action: @escaping () -> Void
    ) {
      self.initialSeed = initialSeed
      self._isCreatorPresented = isCreatorPresented
      self.action = action
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Text(R.string.create.subheadline())
          .font(.custom(.regular, relativeTo: .subheadline))
          .padding(.horizontal, 20)
        
        Spacer()
                  
        SlotMachine(
          seed: $seed,
          shouldShowAllTraits: $shouldShowAllTraits,
          initialSeed: initialSeed,
          showShadow: false,
          animateEntrance: true
        )
          .disabled(true)
          .drawingGroup()

        OutlineButton(
          text: R.string.create.proceedTitle(),
          largeAccessory: { Image.fingergunsRight.shakeRepeatedly() },
          action: action)
          .controlSize(.large)
          .padding(.horizontal, 40)
        
        Spacer()
      }
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun card and the top of the tab view
      .padding(.bottom, 20)
      .softNavigationTitle(R.string.create.title(), rightAccessory: {
        SoftButton(
          text: "New",
          largeAccessory: { Image.new },
          action: { isCreatorPresented.toggle() })
      })
    }
  }
}
