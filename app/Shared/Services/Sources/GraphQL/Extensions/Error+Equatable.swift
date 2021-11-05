//
//  Error+Equatable.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation

/**
 This is a equality on any 2 instance of Error.
 */
public func == (_ lhs: Error, _ rhs: Error) -> Bool {
  return lhs.reflectedString == rhs.reflectedString
}

public extension Error {
  var reflectedString: String {
    return String(reflecting: self)
  }
  
  func isEqual(to: Self) -> Bool {
    return self.reflectedString == to.reflectedString
  }
}

public extension NSError {
  func isEqual(to: NSError) -> Bool {
    let lhs = self as Error
    let rhs = to as Error
    return self.isEqual(to) && lhs.reflectedString == rhs.reflectedString
  }
}
