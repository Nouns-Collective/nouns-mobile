//
//  ToggleRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.12.21.
//

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
