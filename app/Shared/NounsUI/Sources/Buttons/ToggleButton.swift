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

/// Settings toggled row to display options.
public struct ToggleButton: View {
  private let text: String
  private let icon: Image
  @Binding private var isOn: Bool
  
  public init(_ text: String, icon: Image, isOn: Binding<Bool>) {
    self.text = text
    self.icon = icon
    self._isOn = isOn
  }
  
  public var body: some View {
    OutlineButton(
      text: text,
      icon: { icon },
      accessory: {
        OutlineToggle(isOn: $isOn)
      },
      action: { })
      .controlSize(.large)
  }
}

struct ToggleButton_Previews: PreviewProvider {
  
  static var previews: some View {
    ToggleButton(
      "O'Clock Noun",
      icon: .speaker,
      isOn: .constant(true))
  }
}
