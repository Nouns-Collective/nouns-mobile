//
//  NounCreator.AccessoryItems.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import NounsUI

extension NounCreator {
  
  struct AccessoryItems: ViewModifier {
    
    @ObservedObject var viewModel: ViewModel
    
    /// Designated action for the done button
    let done: () -> Void
    
    /// Designated action for the cancel button
    let cancel: () -> Void
    
    func body(content: Content) -> some View {
      content
        .softNavigationItems(leftAccessory: {
          SoftButton(
            icon: { Image.xmark },
            action: cancel)
          
        }, rightAccessory: {
          SoftButton(
            text: R.string.shared.done(),
            smallAccessory: { Image.checkmark },
            action: done)
            .emptyPlaceholder(when: viewModel.mode == .done) {
              EmptyView()
            }
        })
    }
  }
}
