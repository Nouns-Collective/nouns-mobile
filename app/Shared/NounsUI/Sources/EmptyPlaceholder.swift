//
//  EmptyPlaceholderView.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI

extension View {
    
    /// Displays a placeholder with a given message if condition is valid.
    /// - Parameters:
    ///   - condition: To validate for placeholder visibility.
    ///   - message: to specify the current state.
    public func emptyPlaceholder(
      when condition: Bool,
      message: String
    ) -> some View {
        modifier(EmptyPlaceholder(
            isEmpty: condition,
            emptyView: EmptyPlaceholderTextView(message: message))
        )
    }
    
    /// Displays a placeholder with a given message if condition is valid.
    /// - Parameters:
    ///   - condition: To validate for placeholder visibility.
    ///   - view: An empty state view
    public func emptyPlaceholder<EmptyView: View>(
      when condition: Bool,
      @ViewBuilder view: @escaping () -> EmptyView
    ) -> some View {
        modifier(EmptyPlaceholder(
            isEmpty: condition,
            emptyView: view())
        )
    }
}

private struct EmptyPlaceholderTextView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.custom(.medium, relativeTo: .headline))
            .padding()
    }
}

private struct EmptyPlaceholder<EmptyView: View>: ViewModifier {
    let isEmpty: Bool
    let emptyView: EmptyView
    
    func body(content: Content) -> some View {
        if isEmpty {
            emptyView
        } else {
            content
        }
    }
}
