// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
  
  /// Boolean value to determine if more items should continue to be loaded when the user approaches the bottom of the list
  private let shouldLoadMore: Bool
  
  /// Boolean value to deremine if the client wants to load more AND if the client is not already loading
  public var shouldLoadNow: Bool {
    shouldLoadMore && !isLoading
  }
  
  public init(
    _ data: Data,
    columns: [GridItem],
    spacing: CGFloat = 20,
    isLoading: Bool,
    shouldLoadMore: Bool = true,
    loadMoreAction: @Sendable @escaping () async -> Void,
    placeholder: @escaping () -> Placeholder,
    @ViewBuilder content: @escaping (_ item: Data.Element) -> Content
  ) {
    self.data = data
    self.columns = columns
    self.spacing = spacing
    self.isLoading = isLoading
    self.shouldLoadMore = shouldLoadMore
    self.content = content
    self.loadMoreAction = loadMoreAction
    self.placeholder = placeholder
  }

  public var body: some View {
    LazyVGrid(columns: columns, spacing: spacing) {
      Section(content: {
        ForEach(data) { element in
          content(element)
        }
      }, footer: {
        ZStack {
          if isLoading {
            placeholder()
          } else {
            Color.clear
          }
        }
        .task {
          if shouldLoadNow {
            await loadMoreAction()
          }
        }
      })
    }
  }
}
