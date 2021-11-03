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
                .resizable()
                .scaledToFit()
                .overlay(label)
        }
    }
    
    private var label: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                Text(content)
                    .fontWeight(.medium)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, proxy.size.width*0.11)
                    .padding(.bottom, proxy.size.height*0.23)
                Spacer()
            }
        }
    }
}
