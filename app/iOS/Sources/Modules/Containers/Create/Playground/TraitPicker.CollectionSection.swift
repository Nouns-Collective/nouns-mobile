//
//  TraitCollectionSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

struct TraitCollectionSection<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
  let tag: Int
  let items: Data
  var selected: Data.Element?
  
  private let content: (Data.Element, Int) -> Content
  
  init(tag: Int, items: Data, @ViewBuilder cell: @escaping (_ item: Data.Element, _ index: Int) -> Content) {
    self.tag = tag
    self.items = items
    self.content = cell
  }
  
  var body: some View {
    Section {
      ForEach(0..<items.count, id: \.self) { index in
        content(items[index as! Data.Index], index)
      }
    }
  }
}
