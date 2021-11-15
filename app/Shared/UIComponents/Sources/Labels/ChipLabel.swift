//
//  ChipLabel.swift
//  
//
//  Created by Ziad Tamim on 15.11.21.
//

import SwiftUI

/// A label for user interface items, consisting of
/// an no sign icon with a title.
public struct ChipLabel: View {
    /// Various label's states.
    public enum State {
        case positive
        case negative
        case neutral
    }
    
    private let title: String
    private let state: State
    
    /// A standard label for user interface items, consisting
    /// of an icon with a title for a given state.
    ///
    ///  ```
    ///   ChipLabel("Voted for", state: .positive)
    ///   ChipLabel("Voted against", state: .neutral)
    ///   ChipLabel("Absent for", state: .negative)
    ///   ``
    public init(_ title: String, state: State) {
        self.title = title
        self.state = state
    }
    
    public var body: some View {
        HStack {
            Label("", systemImage: "")
            state.image
            Text(title)
                .font(.custom(.medium, relativeTo: .footnote))
            
        }
        .foregroundColor(state.foregroundColor)
        .contained(textColor: .white, backgroundColor: state.backgroundColor)
    }
}

extension ChipLabel.State {
    
    fileprivate var image: Image {
        switch self {
        case .neutral:
            return Image.noSign
        case .positive:
            return Image.checkmark
        case .negative:
            return Image.xmark
        }
    }
    
    fileprivate var foregroundColor: Color {
        switch self {
        case .neutral:
            return .componentNounsBlack.opacity(0.5)
        case .positive:
            return .white
        case .negative:
            return .white
        }
    }
    
    fileprivate var backgroundColor: Color {
        switch self {
        case .neutral:
            return .componentNounsBlack.opacity(0.15)
        case .positive:
            return .blue
        case .negative:
            return .red
        }
    }
}
