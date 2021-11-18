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
extension View {
  func loading() -> some View {
    environment(\.loading, true)
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
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .opacity(0)
                .overlay {
                    switch style {
                    case .skeleton:
                        SkeletonView()
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

/// A thin dark rectangle to be used as an overlay on existing views during loading states
struct SkeletonView: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 2)
    }
}

extension View {
    func redactable(style: Redactable.Style = .skeleton) -> some View {
        modifier(Redactable(style: style))
    }
}
