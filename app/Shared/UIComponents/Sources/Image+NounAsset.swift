//
//  Image+NounAsset.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-15.
//

import Foundation
import SwiftUI

extension Image {
    
    /// This initializer creates an image using a Noun's trait-provided asset.
    ///
    /// - Parameters:
    ///   - nounTraitName: The name of the Noun's trait image.
    public init(nounTraitName: String) {
        self.init(nounTraitName, bundle: Bundle.module)
    }
}
