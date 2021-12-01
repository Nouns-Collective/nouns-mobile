//
//  PaginatingVGrid.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

import SwiftUI

public let defaultLayout = [
  GridItem(.flexible(), spacing: 20),
  GridItem(.flexible(), spacing: 20)
]

public struct VPageGrid<Data, Content, Placeholder>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View, Placeholder: View {
  
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
  
  /// Column layout for the grid
  private let columns: [GridItem]
  
  /// Spacing of the grid
  private let spacing: CGFloat
  
  public init(
    _ data: Data,
    isLoading: Bool,
    columns: [GridItem] = defaultLayout,
    spacing: CGFloat = 20,
    loadMoreAction: @escaping (_ after: Int) -> Void,
    placeholder: @escaping () -> Placeholder,
    @ViewBuilder content: @escaping (_ item: Data.Element) -> Content
  ) {
    self.data = data
    self.isLoading = isLoading
    self.columns = columns
    self.spacing = spacing
    self.content = content
    self.loadMoreAction = loadMoreAction
    self.placeholder = placeholder
  }
  
  private func loadMore() {
    loadMoreAction(data.count)
  }
  
  public var body: some View {
    LazyVGrid(columns: columns, spacing: spacing) {
      Section(content: {
        ForEach(data) { element in
          content(element)
        }
        
      }, footer: {
        // Load next batch when footer appears.
        placeholder()
          .onAppear(perform: loadMore)
      })
    }
  }
}
