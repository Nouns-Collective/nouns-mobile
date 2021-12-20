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
        case pending
        case active
        case cancelled
        case vetoed
        case queued
        case executed
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
        case .pending:
            return .pending
        case .active:
            return .active
        case .cancelled:
            return .absent
        case .vetoed:
            return .cancel
        case .queued:
            return .queued
        case .executed:
            return .check
        }
    }
    
    fileprivate var foregroundColor: Color {
        switch self {
        case .queued:
            return .componentNounsBlack.opacity(0.5)
        default:
            return .white
        }
    }
    
    fileprivate var backgroundColor: Color {
        switch self {
        case .pending:
            return .blue
        case .active:
            return .componentNounsBlack
        case .cancelled:
            return .componentNounsBlack.opacity(0.7)
        case .vetoed:
            return .componentSoftCherry
        case .queued:
            return .componentNounsBlack.opacity(0.22)
        case .executed:
            return .green
        }
    }
}
