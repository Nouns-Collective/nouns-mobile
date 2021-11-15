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
            
        }  else if T.self == [Proposal].self {
            data = try decoder.decode("data", "proposals")
            
        } else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Encoded payload not of an expected type")
            
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}

extension Proposal: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(String.self, forKey: AnyCodingKey("id"))
        status = try container.decode(ProposalStatus.self, forKey: AnyCodingKey("status"))
        description = try container.decode(String.self, forKey: AnyCodingKey("description"))
        title = MarkdownParser(content: description).title
    }
    
}

extension Seed {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        background = try Int(container.decode(String.self, forKey: AnyCodingKey("background")))!
        body = try Int(container.decode(String.self, forKey: AnyCodingKey("body")))!
        glasses = try Int(container.decode(String.self, forKey: AnyCodingKey("glasses")))!
        head = try Int(container.decode(String.self, forKey: AnyCodingKey("head")))!
        accessory = try Int(container.decode(String.self, forKey: AnyCodingKey("accessory")))!
    }
}
