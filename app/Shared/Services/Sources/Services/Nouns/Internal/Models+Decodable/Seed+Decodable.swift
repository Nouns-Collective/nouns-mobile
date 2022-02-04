//
//  Seed+Decodable.swift
//  
//
//  Created by Ziad Tamim on 18.12.21.
//

import Foundation

extension Seed: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    guard let backgroundInt = Int(try container.decode(String.self, forKey: AnyCodingKey("background"))),
          let glassesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("glasses"))),
          let headInt = Int(try container.decode(String.self, forKey: AnyCodingKey("head"))),
          let bodyInt = Int(try container.decode(String.self, forKey: AnyCodingKey("body"))),
          let accessoryInt = Int(try container.decode(String.self, forKey: AnyCodingKey("accessory")))
    else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not convertible to an Integer")
      
      throw DecodingError.dataCorrupted(context)
    }
    
    background = backgroundInt
    glasses = glassesInt
    head = headInt
    body = bodyInt
    accessory = accessoryInt
  }
}
