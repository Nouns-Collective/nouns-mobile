//
//  DefaultRow.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.12.21.
//

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
            .font(.custom(.regular, size: 17))
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
