//
//  PaginatingList.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

import SwiftUI

struct PaginatingList<Data: RandomAccessCollection, Content: View, Placeholder: View>: View where Data.Element: Identifiable {
  
  /// The data for the list content
  private let data: Data
  
  /// The content view for a single data element
  private let content: (Data.Element) -> Content
  
  /// A method to call after reaching the bottom of the scroll view, to load more content
  private let loadMoreAction: (_ after: Int) -> Void
  
  /// A placeholder view to show at the bottom of the list while loading more nouns
  private let placeholder: () -> Placeholder
  
  /// A boolean value to determine whether or not to show the placeholder views at the bottom of the list
  private let isLoading: Bool
  
  init(
    _ data: Data,
    isLoading: Bool,
    @ViewBuilder content: @escaping (_ item: Data.Element) -> Content,
    loadMoreAction: @escaping (_ after: Int) -> Void,
    placeholderView: @escaping () -> Placeholder
  ) {
    self.data = data
    self.isLoading = isLoading
    self.content = content
    self.loadMoreAction = loadMoreAction
    self.placeholder = placeholderView
  }
  
  private func loadMoreIfNecessary(_ item: Data.Element) {
    guard data.last?.id == item.id else { return }
    loadMoreAction(data.count)
  }
  
  var body: some View {
    ForEach(data) { element in
      content(element)
        .onAppear {
          self.loadMoreIfNecessary(element)
        }
    }
    
    if isLoading {
      placeholder()
    }
  }
}
