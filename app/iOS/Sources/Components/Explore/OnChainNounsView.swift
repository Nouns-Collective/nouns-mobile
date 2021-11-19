//
//  OnChainNounsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import Combine
import Services

struct OnChainNounsView: View {
  @EnvironmentObject var store: AppStore
  
  var animation: Namespace.ID
  @Binding var selected: Noun?
  @Binding var isPresentingActivity: Bool
  
  private var isInitiallyLoading: Bool {
    store.state.onChainNouns.isLoading && store.state.onChainNouns.nouns.isEmpty
  }
  
  let columns = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20)
  ]
  
  var body: some View {
    if isInitiallyLoading {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(0..<4) { _ in
          OnChainNounPlaceholderCard()
        }
      }
      .loading()
      .disabled(true)
    } else {
      LazyVGrid(columns: columns, spacing: 20) {
        PaginatingList(store.state.onChainNouns.nouns, isLoading: store.state.onChainNouns.isLoading, content: { noun in
          OnChainNounCard(
            animation: animation,
            noun: noun)
            .id(noun.id)
            .matchedGeometryEffect(id: "noun-\(noun.id)", in: animation)
            .onTapGesture {
              withAnimation(.spring()) {
                selected = noun
              }
            }
        }, loadMoreAction: {
          store.dispatch(FetchOnChainNounsAction(after: $0))
        }, placeholderView: {
          ForEach(0..<2) { _ in
            OnChainNounPlaceholderCard()
              .loading()
          }
        })
      }
    }
  }
}
  
struct Previews: PreviewProvider {
  @Namespace static var ns
  
  static var previews: some View {
    OnChainNounsView(animation: ns, selected: .constant(nil), isPresentingActivity: .constant(false))
  }
}
