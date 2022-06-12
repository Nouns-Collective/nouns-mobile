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

/// Default settings row to display a leading & trailing with accessory.
public struct DefaultButton: View {
  private let leading: String
  private let trailing: String?
  private let icon: Image
  private let action: () -> Void
  
  public init(
    leading: String,
    trailing: String? = nil,
    icon: Image,
    action: @escaping () -> Void
  ) {
    self.leading = leading
    self.trailing = trailing
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    OutlineButton(
      text: leading,
      icon: { icon },
      accessory: {
        if let trailingText = trailing {
          Text(trailingText)
            .font(.custom(.regular, relativeTo: .subheadline))
            .foregroundColor(Color.componentNounsBlack.opacity(0.5))
        }
      },
      smallAccessory: { Image.squareArrowDown },
      action: action)
      .controlSize(.large)
  }
}

struct DefaultButton_Previews: PreviewProvider {
    
    static var previews: some View {
        DefaultButton(
          leading: "Share with friends",
          icon: .share,
          action: { })
    }
}
