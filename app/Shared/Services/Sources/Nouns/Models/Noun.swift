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
    //    public let seed: Seed
}

/// The seed used to determine the Noun's traits.
public struct Seed: Decodable {
    
    /// The background trait.
    public let background: Trait
    
    /// The glasses trait.
    public let glasses: Trait
    
    /// The head trait.
    public let head: Trait
    
    /// The body trait.
    public let body: Trait
    
    /// The accessory trait.
    public let accessory: Trait
}

/// The owner of the Noun
public struct Account: Decodable {
    
    /// An Account is any address that holds any
    /// amount of Nouns, the id used is the blockchain address.
    public let id: String
}
