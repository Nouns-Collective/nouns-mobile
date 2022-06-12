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

/// A label for user interface items, consisting of nested labels.
public struct CompoundLabel<Title>: View where Title: View {
  private let icon: Image
  private let title: Title
  private let caption: String
  
  /// Creates a label with a icon image, title view, and a caption.
  ///
  /// ```
  /// CompoundLabel(SafeLabel("98.00", icon: .eth),
  ///              icon: .currentBid,
  ///              caption: "Current bid")
  ///
  /// CompoundLabel(Text("98.00"),
  ///              icon: .currentBid,
  ///              caption: "Current bid")
  /// ```
  ///
  /// - Parameters:
  ///    - title: A title view.
  ///    - icon: An instance of image resource.
  ///    - caption: of the title provided.
  public init(_ title: () -> Title, icon: Image, caption: String) {
    self.icon = icon
    self.title = title()
    self.caption = caption
  }
  
  public var body: some View {
    
    HStack {
      icon
      VStack(alignment: .leading, spacing: 0) {
        title
          .font(.custom(.bold, relativeTo: .footnote).monospacedDigit())
          .redactable(style: .skeleton)
        
        Text(caption)
          .font(.custom(.regular, relativeTo: .footnote).monospacedDigit())
          .redactable(style: .skeleton)
      }
    }
  }
}
