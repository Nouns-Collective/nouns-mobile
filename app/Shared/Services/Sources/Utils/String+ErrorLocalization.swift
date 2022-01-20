//
//  File.swift
//  
//
//  Created by Ziad Tamim on 19.01.22.
//

import Foundation

/// Set a string to represent an error.
extension String: LocalizedError {
  
  public var errorDescription: String? {
    self
  }
}
