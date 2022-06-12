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
