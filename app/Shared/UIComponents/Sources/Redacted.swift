//
//  Redacted.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-17.
//

import SwiftUI

extension RedactionReasons {
    public static let loading = RedactionReasons(rawValue: 1 << 10)
}

struct Redactable: ViewModifier {
    @Environment(\.redactionReasons) private var reasons
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if reasons.contains(.loading) {
            content
                .opacity(0)
                .overlay {
                    SkeletonView()
                }
        } else {
            content
        }
    }
}

struct SkeletonView: View {
    init() {}
    
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 2)
    }
}

extension View {
    func redactable(loading: Bool) -> some View {
        if loading {
            return AnyView(modifier(Redactable()))
        } else {
            return AnyView(self)
        }
    }
}
