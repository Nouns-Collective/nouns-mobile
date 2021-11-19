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
            
            label
                .offset(y: -10)
                .frame(width: .infinity)
                .background(
                    Image("speech.bubble", bundle: .module)
                        .resizable()
                        .scaledToFill()
                )
                .frame(maxWidth: .infinity, minHeight: 112)
        }
    }
    
    private var label: some View {
        Text(content)
            .font(Font.custom(.bold, relativeTo: .body))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

/// State indicator for occurred errors.
public struct ErrorStateView: View {
    private let message: String
    
    /// Create a state view that display a message.
    ///
    /// ```swift
    /// ZStack {
    ///     Gradient.bubbleGum
    ///         .ignoresSafeArea()
    ///
    ///     ErrorStateView("Dude, something’s wrong with the auction")
    ///         .padding()
    /// }
    /// ```
    ///
    /// - Parameter title: The message to communicate.
    public init(_ message: String) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            SpeechBubble(message)
            Image("noun-error-persona", bundle: .module)
            OutlineButton(text: "Try again",
                          icon: { Image.retry },
                          action: { },
                          fill: [.width])
        }
    }
}

struct SpeedBubble_preview: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            Gradient.bubbleGum
                .ignoresSafeArea()
            
            ErrorStateView("Dude, something’s wrong with the auction")
                .padding()
        }
        .onAppear {
            UIComponents.configure()
        }
    }
}
