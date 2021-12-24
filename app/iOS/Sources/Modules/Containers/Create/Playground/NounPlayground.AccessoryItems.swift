//
//  NounPlayground.AccessoryItems.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import UIComponents

extension NounPlayground {
  
  struct AccessoryItems: ViewModifier {
    
    /// Designated action for the done button
    let done: () -> Void
    
    /// Designated action for the dismiss button
    let dismiss: () -> Void
    
    func body(content: Content) -> some View {
      content
        .softNavigationItems(leftAccessory: {
          SoftButton(
            icon: { Image.xmark },
            action: dismiss)
          
        }, rightAccessory: {
          SoftButton(
            text: R.string.shared.done(),
            smallAccessory: { Image.checkmark },
            action: done)
        })
    }
  }
}
