//
//  Noun+Decodable.swift
//  
//
//  Created by Ziad Tamim on 18.12.21.
//

import Foundation

extension Noun: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    owner = try container.decode(Account.self, forKey: AnyCodingKey("owner"))
    seed = try container.decode(Seed.self, forKey: AnyCodingKey("seed"))
    name = try container.decodeIfPresent(
      String.self,
      forKey: AnyCodingKey("name")
    ) ?? "Untitled"
    
    createdAt = Date()
    updatedAt = Date()
    isNounderOwned = false
  }
}
