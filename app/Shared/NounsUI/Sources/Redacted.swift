// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

/// A custom environment key for setting the loading state of a view and it's child views
private struct LoadingState: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var loading: Bool {
        get { self[LoadingState.self] }
        set { self[LoadingState.self] = newValue }
    }
}

/// A view extension that sets the loading environment key to true for the specified view and it's children view
public extension View {
    func loading(when condition: Bool = true) -> some View {
        environment(\.loading, condition)
    }
}

/// The view modifier that applies a skeleton view if the environment loading property is set to true
public struct Redactable: ViewModifier {
    @Environment(\.loading) private var isLoading
    
    let style: Style
    
    public enum Style {
        case skeleton
        case gray
    }
    
    /// A thin dark rectangle to be used as an overlay on existing views during loading states
    private var skeletonView: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 2)
    }
    
    public func body(content: Content) -> some View {
        content
            .opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    switch style {
                    case .skeleton:
                        skeletonView
                    case .gray:
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                    }
                }
            }
    }
}

public extension View {
    func redactable(style: Redactable.Style) -> some View {
        modifier(Redactable(style: style))
    }
}
