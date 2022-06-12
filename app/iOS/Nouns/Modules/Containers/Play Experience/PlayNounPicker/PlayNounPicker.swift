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

struct PlayNounPicker: View {
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var selectedNoun: Noun?
  @State private var isCreatorPresented: Bool = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.playExperience.self
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      OffChainNounsFeed(
        title: localize.chooseNoun(),
        selection: $selectedNoun,
        emptyPlaceholder: {
          
          // On the empty list of offline names, presents options
          // to create a new noun.
          EmptyView(action: {
            isCreatorPresented.toggle()
          })
        })
        .softNavigationItems(leftAccessory: {
          SoftButton(
            icon: { Image.back },
            action: { dismiss() })
          
        }, rightAccessory: {
          SoftButton(
            text: localize.createNounAction(),
            largeAccessory: { Image.new },
            action: { isCreatorPresented.toggle() })
        })
        .padding(.top, 50)
    }
    .background(Gradient.blueberryJam)
    .overlay(.componentPerriwinkle, edge: .top)
    .ignoresSafeArea(edges: .top)
    // Gives the ability to create a new noun offline by driving
    // the user to the create experience.
    .fullScreenCover(isPresented: $isCreatorPresented) {
      NounCreator()
    }
    // Displays the playground to play with the selected noun.
    .fullScreenCover(item: $selectedNoun, onDismiss: {
      selectedNoun = nil
      
    }, content: { noun in
      NounPlayground(viewModel: .init(noun: noun))
        .addBottomSheet()
    })
    .onAppear {
      outlineTabBarVisibility.hide()
    }
  }
}
