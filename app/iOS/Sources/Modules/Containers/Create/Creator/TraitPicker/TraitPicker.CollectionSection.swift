//
//  TraitCollectionSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI

extension NounCreator {

  struct TraitCollectionSection<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable, Data.Index == Int {
    let items: Data
    
    private let content: (Data.Element, Int) -> Content
    
    init(items: Data, @ViewBuilder cell: @escaping (_ item: Data.Element, _ index: Int) -> Content) {
      self.items = items
      self.content = cell
    }
    
    var body: some View {
      Section {
        ForEach(0..<items.count, id: \.self) { index in
          content(items[index], index)
        }
      }
    }
  }
}
