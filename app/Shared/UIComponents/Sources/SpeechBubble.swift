//
//  SpeechBubble.swift
//  
//
//  Created by Ziad Tamim on 01.11.21.
//

import SwiftUI

/// A view to display a text view with a speech bubble background
public struct SpeechBubble: View {
    private let content: String
    
    /// Creates a text view that displays a stored string with a speech bubble on the background.
    ///
    /// Use this initializer to create a text view that displays — without
    /// localization — the text in a string variable.
    ///
    ///     SpeechBubble(someString) // Displays the contents of `someString` without localization.
    ///
    /// - Parameter content: The string value to display without localization.
    public init(_ content: String) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            Image("speech.bubble", bundle: .module)
            Text(content)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.bottom, 20)
                .padding(.horizontal, 40)
        }
    }
}
