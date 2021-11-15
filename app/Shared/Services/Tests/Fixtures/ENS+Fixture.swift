//
//  ENS+Fixture.swift
//  
//
//  Created by Ziad Tamim on 14.11.21.
//

import Foundation
@testable import Services

extension ENSDomain {
    
    static var fixture: Self = {
        ENSDomain(id: "example.eth",
                  name: "0x2573c60a6d127755aa2dc85e342f7da2378a0cc5")
    }()
}
