//
//  RuntimeError.swift
//  
//
//  Created by Ziad Tamim on 12.02.22.
//

import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
