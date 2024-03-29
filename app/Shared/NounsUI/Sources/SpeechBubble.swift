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
                .offset(y: -14)
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
            // TODO: - Update font to Space Mono
            .font(Font.custom(.medium, relativeTo: .subheadline))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding()
    }
}

/// State indicator for occurred errors.
public struct ErrorStateBubble: View {
    
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
                .resizable()
                .scaledToFit()
            OutlineButton(text: "Try again",
                          icon: { Image.retry },
                          action: { })
        }
    }
}

/// State indicator for occurred errors.
public struct NounSpeechBubble: View {
    
    private let message: String
    
    private let noun: String
    
    private let spacing: CGFloat
    
    /// Create a noun view that display a message.
    ///
    /// ```swift
    /// ZStack {
    ///     Gradient.bubbleGum
    ///         .ignoresSafeArea()
    ///
    ///     NounSpeechView("Dude, something’s wrong with the auction", noun: "talking-noun")
    ///         .padding()
    /// }
    /// ```
    ///
    /// - Parameter title: The message to communicate.
    public init(_ message: String, noun: String, spacing: CGFloat = -25) {
        self.message = message
        self.noun = noun
        self.spacing = spacing
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            SpeechBubble(message)
            Image(noun, bundle: .module)
                .resizable()
                .scaledToFit()
        }
    }
}

struct SpeechBubble_preview: PreviewProvider {
    struct PreviewView: View {
        init() {
          NounsUI.configure()
        }
        
        public var body: some View {
            ZStack {
                Gradient.lemonDrop
                    .ignoresSafeArea()
                
                NounSpeechBubble("One noun, everyday, forever.", noun: "talking-noun")
                    .padding()
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
