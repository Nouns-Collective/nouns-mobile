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
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  @StateObject private var viewModel = ViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        /// A temporary workaround for a UI issue where the `OffChainNounsFeed` requires a `ScrollView` in order
        /// to make the feed scrollable. However, the `SlotMachine` does not behave as expected when inside a `ScrollView`
        /// (when the offline noun feed is empty). Therefore, the scroll view must be removed using a view modifier whenever the noun feed
        /// is empty in order to show the empty placeholder view.
        ///
        /// In the case that there are nouns, the scroll view will be re-added. Since we want the navigation bar (navigation title + right *New* button)
        /// to scroll with the content as well, the preference key for setting the navigation bar items must be **inside** the `ScrollView`, which is
        /// why the `OffChainNounsFeed` takes in an optional `navigationTitle` and `navigationRightBarItem` so that the appropriate
        /// preference values can be set from within the feed.
        ///
        /// Ideally, the `SlotMachine` should be fixed so that there is no weird behaviour when it's inside a `ScrollView`, but a solution
        /// couldn't be found in a reasonable time so this workaround was added for the time being to progress towards feature-completion.
        ///
        /// Related task: https://github.com/secretmissionsoftware/nouns-ios/issues/342
        OffChainNounsFeed(
          selection: $viewModel.selectedNoun,
          isScrollable: true,
          navigationTitle: R.string.create.title(),
          navigationRightBarItem: {
            SoftButton(
              text: "New",
              largeAccessory: { Image.new },
              action: { viewModel.isCreatorPresented.toggle() })
          }, emptyPlaceholder: {
            EmptyNounsView(
              initialSeed: viewModel.initialSeed,
              isCreatorPresented: $viewModel.isCreatorPresented
            ) {
              viewModel.isCreatorPresented.toggle()
            }
          })
      }
      .background(Gradient.freshMint)
      .overlay(.componentAqua, edge: .top)
      .ignoresSafeArea(edges: .top)
      // Presents more details about the settled auction.
      .fullScreenCover(item: $viewModel.selectedNoun, onDismiss: {
        viewModel.selectedNoun = nil
      }, content: {
        OffChainNounProfile(viewModel: .init(noun: $0))
      })
      .fullScreenCover(isPresented: $viewModel.isCreatorPresented) {
        NounCreator(viewModel: .init(initialSeed: viewModel.initialSeed))
      }
      .onDisappear {
        // Randomize noun everytime tab is revisited
        viewModel.randomizeNoun()
      }
    }
  }
}
