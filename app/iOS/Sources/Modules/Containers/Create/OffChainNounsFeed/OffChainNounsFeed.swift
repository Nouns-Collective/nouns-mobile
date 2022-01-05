//
//  OfflineFeed.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import UIComponents
import Services

/// A view to display a list of all the nouns that the user has created.
struct OffChainNounsFeed: View {
  @StateObject var viewModel = ViewModel()
  @Binding var isPlaygroundPresented: Bool
  
  @State private var selection: Noun?
  @Namespace private var namespace
  
  var body: some View {
    VStack(spacing: 20) {
      ForEach(viewModel.nouns, id: \.self) { noun in
        OffChainNounCard(viewModel: .init(noun: noun), animation: namespace)
          .id(noun.id)
          .onTapGesture {
            selection = noun
          }
      }
    }
    .emptyPlaceholder(when: viewModel.nouns.isEmpty) {
      OffChainFeedPlaceholder {
        isPlaygroundPresented.toggle()
      }
    }
    .onAppear {
      Task {
        await viewModel.fetchOffChainNouns()
      }
    }
    // Presents more details about the settled auction.
    .fullScreenCover(item: $selection, onDismiss: {
      selection = nil

    }, content: {
      OffChainNounProfile(viewModel: .init(noun: $0))
    })
  }
}
