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

public struct PageIndicator<SelectionValue>: View where SelectionValue: Hashable {
  public let pages: [SelectionValue]
  public let selection: SelectionValue
  
  public init(pages: [SelectionValue], selection: SelectionValue) {
    self.pages = pages
    self.selection = selection
  }
  
  public var body: some View {
    HStack {
      ForEach(pages, id: \.hashValue) { value in
        Circle()
          .frame(width: 8, height: 8, alignment: .center)
          .foregroundColor(Color.componentNounsBlack)
          .opacity(value == selection ? 1 : 0.1)
      }
    }
  }
}
