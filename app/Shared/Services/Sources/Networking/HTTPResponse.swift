//
//  HTTPResponse.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-25.
//

import Foundation

/// Parent container for response data
public struct HTTPResponse<T> {
  
  /// Data retrived from the response.
  public let data: T
}

extension HTTPResponse: Decodable where T: Decodable {
  private enum CodingKeys: String, CodingKey {
    case data
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decode(T.self, forKey: .data)
  }
}

/// Pagination.
public struct Page<T> {
  
  /// Data retrived from the response.
  public let data: T
}

extension Page: Decodable where T: Decodable {
  public init(from decoder: Decoder) throws {
    // TODO: - Find a better solution for setting coding keys, based on type (https://github.com/secretmissionsoftware/nouns-ios/issues/36)
    switch T.self {
    case is Array<Noun>.Type:
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decode(T.self, forKey: CodingKeys(stringValue: "nouns"))
    case is Array<Proposal>.Type:
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decode(T.self, forKey: CodingKeys(stringValue: "proposals"))
    case is Array<ENSDomain>.Type:
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decode(T.self, forKey: CodingKeys(stringValue: "domains"))
    default:
      throw ResponseDecodingError.typeNotFound(type: T.self)
    }
  }
}
