//
//  RequestError+Equatable.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation
@testable import Services

extension RequestError: Equatable {
    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (http(let lStatusCode), http(let rStatusCode)):
            return lStatusCode == rStatusCode
        default:
            return rhs == lhs
        }
    }
}
