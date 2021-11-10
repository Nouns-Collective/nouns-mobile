//
//  Config.swift
//  
//
//  Created by Ziad Tamim on 10.11.21.
//

import SwiftUI

public struct UIComponents {
    
    /// Configures all the UI of the package
    public static  func configure() {
        registerFonts()
    }
    
    public static func registerFonts() {
        GTWalsheim.allCases.forEach {
            Font.registerFont(
                bundle: .module,
                name: $0.rawValue,
                type: FontType.true)
        }
    }
}
