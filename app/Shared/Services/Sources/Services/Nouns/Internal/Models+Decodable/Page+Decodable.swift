//
//  Models+Decodable.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

extension Page: Decodable {
  
  public init(from decoder: Decoder) throws {
    if T.self == [Noun].self {
      data = try decoder.decode("data", "nouns")
      
    } else if T.self == [Vote].self {
      data = try decoder.decode("data", "noun", "votes")
      
    } else if T.self == [ENSDomain].self {
      data = try decoder.decode("data", "domains")
      
    } else if T.self == [Auction].self {
      data = try decoder.decode("data", "auctions")
      
    } else if T.self == [Proposal].self {
      data = try decoder.decode("data", "proposals")
      
    } else if T.self == [Bid].self {
      data = try decoder.decode("data", "bids")
      
    } else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not of an expected type")
      
      throw DecodingError.typeMismatch(T.self, context)
    }
  }
}
