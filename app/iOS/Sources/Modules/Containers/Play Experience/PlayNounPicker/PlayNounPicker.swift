//
//  PlayNounPicker.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-08.
//

import SwiftUI
import UIComponents
import Services

struct PlayNounPicker: View {
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
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
    }
    .background(Gradient.blueberryJam)
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
    })
  }
}
