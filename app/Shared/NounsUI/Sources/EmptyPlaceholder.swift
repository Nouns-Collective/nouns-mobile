// Copyright (C) 2022 Nouns Collective
//
// Originally authored by  Ziad Tamim
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
