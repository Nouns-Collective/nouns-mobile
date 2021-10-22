//
//  GraphQLError+QueryError.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public extension GraphQLError {
  func queryErrorReason() -> QueryError.Reason {
    let locations = self.locations?.map { QueryError.Location(line: $0.line, column: $0.column) }
    return QueryError.Reason(message: self.message, locations: locations)
  }
}

public extension Array where Element == GraphQLError {
  func queryError() -> QueryError {
    let reasons = self.map { $0.queryErrorReason() }
    return QueryError.invalidQuery(reasons: reasons)
  }
}
