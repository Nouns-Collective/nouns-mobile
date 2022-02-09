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
struct OffChainNounsFeed<PlaceholderView: View>: View {
  @Namespace private var namespace

  @StateObject var viewModel = ViewModel()
  @Binding var selection: Noun?
  
  private let title: String?

  private let emptyPlaceholder: () -> PlaceholderView
  
  init(
    title: String? = nil,
    selection: Binding<Noun?>,
    @ViewBuilder emptyPlaceholder: @escaping () -> PlaceholderView
  ) {
    self.title = title
    self._selection = selection
    self.emptyPlaceholder = emptyPlaceholder
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let title = title {
        Text(title)
          .font(.custom(.bold, size: 36))
      }
      
      ForEach(viewModel.nouns, id: \.self) { noun in
        OffChainNounCard(viewModel: .init(noun: noun), animation: namespace)
          .id(noun.id)
          .onTapGesture {
            selection = noun
          }
      }
    }
    .emptyPlaceholder(when: viewModel.nouns.isEmpty) {
      emptyPlaceholder()
    }
    .onAppear {
      Task {
        await viewModel.fetchOffChainNouns()
      }
    }
  }
}
