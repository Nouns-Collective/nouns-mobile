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

/// Pagination.
public struct Page<T> {
  
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
