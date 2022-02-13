//
//  CreateView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Displays the Create Experience route.
struct CreateExperience: View {
  
  @State private var isCreatorPresented = false
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  @State private var selectedNoun: Noun?
  
  private let initialSeed: Seed
  
  init() {
    self.initialSeed = AppCore.shared.nounComposer.randomSeed()
  }
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        OffChainNounsFeed(
          selection: $selectedNoun,
          isScrollable: true,
          navigationTitle: R.string.create.title(),
          navigationRightBarItem: {
            SoftButton(
              text: "New",
              largeAccessory: { Image.new },
              action: { isCreatorPresented.toggle() })
          }, emptyPlaceholder: {
            EmptyNounsView(
              initialSeed: initialSeed,
              isCreatorPresented: $isCreatorPresented
            ) {
              isCreatorPresented.toggle()
            }
          })
      }
      .fullScreenCover(isPresented: $isCreatorPresented) {
        NounCreator(viewModel: .init(initialSeed: initialSeed))
      }
      .background(Gradient.freshMint)
      .ignoresSafeArea(edges: .top)
      // Presents more details about the settled auction.
      .fullScreenCover(item: $selectedNoun, onDismiss: {
        selectedNoun = nil
      }, content: {
        OffChainNounProfile(viewModel: .init(noun: $0))
      })
      .fullScreenCover(isPresented: $isCreatorPresented) {
        NounCreator(viewModel: .init(initialSeed: initialSeed))
      }
    }
  }
}
