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

internal struct ScrollableView: ViewModifier {
  
  func body(content: Content) -> some View {
    ScrollView(.vertical, showsIndicators: false) {
      content
    }
  }
}

public extension View {
  
  /// A view extension that makes the content of the view scrollable given a specified condition is `true`
  func scrollable(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(ScrollableView()))
    } else {
      return AnyView(self)
    }
  }
}
