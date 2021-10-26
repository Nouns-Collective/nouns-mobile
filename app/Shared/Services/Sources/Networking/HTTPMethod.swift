//
//  HTTPMethod.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

public enum HTTPMethod {
  case get
  case post(contentType: ContentType)
  case put
  case delete
  
  public enum ContentType {
    case json
    case undefined
  }
}

extension HTTPMethod: CustomStringConvertible {
  public var description: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .delete:
      return "DELETE"
    }
  }
}
