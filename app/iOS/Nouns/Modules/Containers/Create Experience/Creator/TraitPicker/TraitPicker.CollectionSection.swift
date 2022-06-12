// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

extension NounCreator {

  struct TraitCollectionSection<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable, Data.Index == Int {
    let type: TraitType
    let items: Data
    
    private let content: (Data.Element, Int) -> Content
    
    init(type: TraitType, items: Data, @ViewBuilder cell: @escaping (_ item: Data.Element, _ index: Int) -> Content) {
      self.type = type
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
