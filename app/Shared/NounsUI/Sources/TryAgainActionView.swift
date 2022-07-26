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

/// A reusable view to display an error message and a button to retry an action
public struct TryAgain: View {
  
  /// The error message to display
  private let message: String
  
  /// The text on the action button
  private let buttonText: String
  
  /// The designated action for the button
  private let action: () -> Void
  
  public init(
    message: String,
    buttonText: String,
    retryAction: @escaping () -> Void
  ) {
    self.message = message
    self.buttonText = buttonText
    self.action = retryAction
  }
  
  public var body: some View {
    VStack(alignment: .center) {
      Text(message)
          .font(.custom(.medium, relativeTo: .headline))
          .padding()
          .opacity(0.6)
      
      OutlineButton(text: buttonText) {
        Image.retry
      } action: {
        action()
      }
    }
  }
}
