//
//  Noun.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

/// The Noun
public struct Noun: Decodable {
    
    /// The Noun's ERC721 token id
    public let id: String
    
    ///  The owner of the Noun
    public let owner: Account
    
    /// The seed used to determine the Noun's traits.
    public let seed: Seed
}

/// The seed used to determine the Noun's traits.
public struct Seed: Decodable {
    
    /// The background trait.
    public let background: Int//Trait
    
    /// The glasses trait.
    public let glasses: Int//Trait
    
    /// The head trait.
    public let head: Int//Trait
    
    /// The body trait.
    public let body: Int//Trait
    
    /// The accessory trait.
    public let accessory: Int//Trait
}

/// The owner of the Noun
public struct Account: Decodable {
    
    /// An Account is any address that holds any
    /// amount of Nouns, the id used is the blockchain address.
    public let id: String
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
