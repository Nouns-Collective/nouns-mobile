//
//  QueryError+Equatable.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation
@testable import Services

extension QueryError: Equatable {
    public static func == (lhs: QueryError, rhs: QueryError) -> Bool {
        switch (lhs, rhs) {
        case (invalidQuery(reasons: let lReasons), invalidQuery(reasons: let rReasons)):
                return lReasons == rReasons
        default:
            return lhs == rhs
        }
    }
}
