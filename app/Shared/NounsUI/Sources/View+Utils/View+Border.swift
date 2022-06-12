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

extension View {
  
  /// Applies border to the specified edges.
  ///
  /// - Parameters:
  ///   - width: The thickness of the border; if not provided, the default is 1 pixel.
  ///   - edges: The alignment for border in relation to this view.
  ///   - color: Sets the color of the border.
  public func border(width: CGFloat = 1, edges: Set<Edge>, color: Color) -> some View {
    overlay(Group {
      if edges.contains(.top) {
        Divider().frame(height: width).background(color)
      }
    }, alignment: .top)
    .overlay(Group {
      if edges.contains(.bottom) {
        Divider().frame(height: width).background(color)
      }
    }, alignment: .bottom)
    .overlay(Group {
      if edges.contains(.leading) {
        Divider().frame(height: width).background(color)
      }
    }, alignment: .leading)
    .overlay(Group {
      if edges.contains(.trailing) {
        Divider().frame(height: width).background(color)
      }
    }, alignment: .trailing)
  }
}
