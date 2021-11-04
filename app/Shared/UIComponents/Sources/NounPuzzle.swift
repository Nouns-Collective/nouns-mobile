//
//  NounPuzzle.swift
//  
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI

@resultBuilder
public struct NounBuilder {
    static func buildBlock(_ traits: Image...) -> [Image] {
        traits.map { $0.interpolation(.none).resizable() }
    }
}

/// Composes a Noun.
public struct NounPuzzle: View {
    private let traits: [Image]
    
    /// Builds a Noun given the traits head, glass, body, and accessory.
    ///
    ///     NounPuzzle {
    ///         Image("accessory-aardvark", bundle: .module)
    ///         Image("head-aardvark", bundle: .module)
    ///         Image("body-green", bundle: .module)
    ///         Image("glasses-hip-rose", bundle: .module)
    ///     }
    ///
    /// - Parameter traits: The Noun's trait with priority order insensitive.
    public init(@NounBuilder traits: () -> [Image]) {
        self.traits = traits()
    }
    
    public var body: some View {
        ZStack {
            ForEach(traits.indices) {
                traits[$0]
            }
        }
        .scaledToFit()
    }
}
