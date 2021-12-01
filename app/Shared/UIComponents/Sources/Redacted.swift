//
//  Redacted.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

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
    func skeleton(when condition: Bool = true) -> some View {
        environment(\.loading, condition)
    }
}

/// The view modifier that applies a skeleton view if the environment loading property is set to true
struct Redactable: ViewModifier {
    @Environment(\.loading) private var isLoading
    
    let style: Style
    
    enum Style {
        case skeleton
        case gray
    }
    
    /// A thin dark rectangle to be used as an overlay on existing views during loading states
    private var skeletonView: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 2)
    }
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .opacity(0)
                .overlay {
                    switch style {
                    case .skeleton:
                        skeletonView
                    case .gray:
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func skeletonWhenRedacted() -> some View {
        modifier(Redactable(style: .skeleton))
    }
    
    func grayWhenRedacted() -> some View {
        modifier(Redactable(style: .gray))
    }
}
