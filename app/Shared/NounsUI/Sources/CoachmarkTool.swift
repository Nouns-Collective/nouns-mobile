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

public struct CoachmarkTool<Content>: View where Content: View {
  
  /// The title of the coachmark tool, residing below the icon image
  private let title: String
  
  /// The icon of the coachmark tool, residing above the title
  private let icon: Image?
  
  private var content: Content?
  
  /// Initializes a coachmark tool with a title and an icon image
  ///
  /// ```swift
  /// CoachmarkTool("Shake to shuffle", image: Image.shakePhone)
  /// ```
  ///
  /// - Parameters:
  ///   - title: The text for the coachmark tool, presented underneath the icon image
  ///   - image: The icon image for the coachmark tool, presented above the title text
  public init(_ title: String, image: Image? = nil) where Content == EmptyView {
    self.title = title
    self.icon = image
  }
  
  /// Initializes a coachmark tool with a title and any view
  ///
  /// ```swift
  /// CoachmarkTool("Shake to shuffle", iconView: { Image.shakePhone })
  /// ```
  ///
  /// - Parameters:
  ///   - title: The text for the coachmark tool, presented underneath the icon image
  ///   - iconView: The icon image for the coachmark tool, presented above the title text
  public init(_ title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
    self.icon = nil
  }
  
  public var body: some View {
    VStack(alignment: .center, spacing: 16) {
      icon?
        .resizable()
        .scaledToFit()
        .frame(width: 32, height: 32, alignment: .center)
      
      content
        .frame(width: 32, height: 32, alignment: .center)
      
      Text(title)
        .font(.custom(.medium, relativeTo: .subheadline))
        .foregroundColor(Color.componentNounsBlack)
    }
  }
}
