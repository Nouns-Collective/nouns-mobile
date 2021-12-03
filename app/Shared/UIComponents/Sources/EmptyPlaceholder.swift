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
    public func emptyPlaceholder(condition: Bool, message: String) -> some View {
        modifier(EmptyPlaceholder(
            isEmpty: condition,
            message: message)
        )
    }
}

private struct EmptyPlaceholder: ViewModifier {
    let isEmpty: Bool
    let message: String
    
    func body(content: Content) -> some View {
        if isEmpty {
            Text(message)
                .font(.custom(.medium, relativeTo: .headline))
                .padding()
            
        } else {
            content
        }
    }
}
