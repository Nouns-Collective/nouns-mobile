//
//  NounPuzzle.swift
//  
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI

/// Composes a Noun.
public struct NounPuzzle: View {
    private let traits: [Image]
    
    /// Builds a Noun given the traits head, glass, body, and accessory.
    ///
    ///     NounPuzzle (
    ///         head: Image("accessory-aardvark"),
    ///         body: Image("head-aardvark"),
    ///         glass: Image("glasses-hip-rose"),
    ///         accessory: Image("body-green")
    ///     )
    ///
    /// - Parameter traits: The Noun's trait.
    public init(head: Image, body: Image, glass: Image, accessory: Image) {
        self.traits = [head, body, glass, accessory]
    }
    
    public var body: some View {
        ZStack {
            ForEach(traits.indices) {
                traits[$0]
                    .interpolation(.none)
                    .resizable()
            }
        }
        .scaledToFit()
    }
}
