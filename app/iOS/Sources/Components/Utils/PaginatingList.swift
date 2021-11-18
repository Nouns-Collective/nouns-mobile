//
//  PaginatingList.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

import SwiftUI

struct PaginatingList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
  
  /// The data for the list content
  private var data: Data
  
  /// The content view for a single data element
  private var content: (Data.Element) -> Content
  
  /// A method to call after reaching the bottom of the scroll view, to load more content
  private var loadMoreAction: (_ after: Int) -> Void
  
  init(
    _ data: Data,
    @ViewBuilder content: @escaping (_ item: Data.Element) -> Content,
    loadMoreAction: @escaping (_ after: Int) -> Void
  ) {
    self.data = data
    self.content = content
    self.loadMoreAction = loadMoreAction
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
  }
}
