//
//  VPageGrid.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

import SwiftUI

public struct VPageGrid<Data, Content, Placeholder>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View, Placeholder: View {
  
  /// The data for the list content
  private let data: Data
  
  /// The content view for a single data element
  private let content: (Data.Element) -> Content
  
  /// A method to call after reaching the bottom of the scroll view, to load more content
  private let loadMoreAction: @Sendable () async -> Void
  
  /// A placeholder view to show at the bottom of the list while loading more nouns
  private let placeholder: () -> Placeholder
  
  /// Column layout for the grid
  private let columns: [GridItem]
  
  /// Spacing of the grid
  private let spacing: CGFloat
    
  /// Boolean value to determine if the grid is loading more items
  private let isLoading: Bool
  
  public init(
    _ data: Data,
    columns: [GridItem],
    spacing: CGFloat = 20,
    isLoading: Bool,
    loadMoreAction: @Sendable @escaping () async -> Void,
    placeholder: @escaping () -> Placeholder,
    @ViewBuilder content: @escaping (_ item: Data.Element) -> Content
  ) {
    self.data = data
    self.columns = columns
    self.spacing = spacing
    self.isLoading = isLoading
    self.content = content
    self.loadMoreAction = loadMoreAction
    self.placeholder = placeholder
  }
 
  /// Loads more items if the last item has appeared or if there are no items loaded yet
  private func loadMoreIfNecessary(_ item: Data.Element?) async {
    guard let item = item else {
      await loadMoreAction()
      return
    }
    
    if item.id == data.last?.id {
      await loadMoreAction()
    }
  }

  public var body: some View {
    LazyVGrid(columns: columns, spacing: spacing) {
      Section(content: {
        ForEach(data) { element in
          content(element)
            .task {
              // Load additional pages if last element of current data collection has appeared
              await loadMoreIfNecessary(element)
            }
        }
        
        if isLoading {
          placeholder()
        }
      })
    }
    .task {
      // Load initial page
      await loadMoreIfNecessary(nil)
    }
  }
}
