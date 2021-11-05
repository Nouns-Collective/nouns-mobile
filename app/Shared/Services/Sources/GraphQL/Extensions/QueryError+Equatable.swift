//
//  QueryError+Equatable.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation

extension QueryError: Equatable {
  public static func == (lhs: QueryError, rhs: QueryError) -> Bool {
    switch (lhs, rhs) {
    case (.noData, .noData):
      return true
    case (.invalidQuery(let lhsReasons), .invalidQuery(let rhsReasons)):
      return lhsReasons == rhsReasons
    case (.request(let lhsError), .request(let rhsError)):
      if let lhsError = lhsError, let rhsError = rhsError {
        return lhsError == rhsError
      } else {
        return lhsError == nil && rhsError == nil
      }
    default:
      return false
    }
  }
}
