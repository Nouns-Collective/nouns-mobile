//
//  OfflineFeed.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import UIComponents
import Services

/// A reusable view to display a list of all the nouns that the user has created.
struct OffChainNounsFeed<PlaceholderView: View, RightBarItem: View>: View {
  @Namespace private var namespace
  @Environment(\.outlineTabViewHeight) private var tabBarHeight

  @StateObject var viewModel = ViewModel()
  @Binding var selection: Noun?
    
  private let title: String?

  private let emptyListPlaceholderView: () -> PlaceholderView
  
  private let navigationTitle: String
  
  private let rightBarItem: () -> RightBarItem
  
  private let isScrollable: Bool
  
  init(
    title: String? = nil,
    selection: Binding<Noun?>,
    isScrollable: Bool = false,
    navigationTitle: String,
    @ViewBuilder navigationRightBarItem: @escaping () -> RightBarItem,
    @ViewBuilder emptyPlaceholder: @escaping () -> PlaceholderView
  ) {
    self.title = title
    self.isScrollable = isScrollable
    self._selection = selection
    self.navigationTitle = navigationTitle
    self.rightBarItem = navigationRightBarItem
    self.emptyListPlaceholderView = emptyPlaceholder
  }
  
  init(
    title: String? = nil,
    selection: Binding<Noun?>,
    isScrollable: Bool = false,
    @ViewBuilder emptyPlaceholder: @escaping () -> PlaceholderView
  ) where RightBarItem == EmptyView {
    self.title = title
    self.isScrollable = isScrollable
    self._selection = selection
    self.navigationTitle = ""
    self.rightBarItem = { EmptyView() }
    self.emptyListPlaceholderView = emptyPlaceholder
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let title = title {
        Text(title)
          .font(.custom(.bold, relativeTo: .title2))
      }
      
      ForEach(viewModel.nouns, id: \.self) { noun in
        OffChainNounCard(viewModel: .init(noun: noun), animation: namespace)
          .id(noun.id)
          .onTapGesture {
            selection = noun
          }
      }
    }
    .padding(.horizontal, 20)
    .padding(.bottom, tabBarHeight)
    // Extra padding between the bottom of the last noun card and the top of the tab view
    .padding(.bottom, 40)
    .if(!navigationTitle.isEmpty, transform: { view in
      view
        .softNavigationTitle(navigationTitle, rightAccessory: {
          rightBarItem()
        })
    })
    .scrollable(isScrollable)
    .emptyPlaceholder(when: viewModel.nouns.isEmpty) {
      emptyListPlaceholderView()
    }
    .task {
      await viewModel.fetchOffChainNouns()
    }
  }
}
