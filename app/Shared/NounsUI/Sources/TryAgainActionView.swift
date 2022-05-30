//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-02-17.
//

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
