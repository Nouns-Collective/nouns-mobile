//
//  Auction.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

/// The Auction
public struct Auction: Decodable {
    /// The Noun's ERC721 token id
    public let id: String
    
    /// The Noun
    public let noun: Noun
    
    /// The current highest bid amount
    public let amount: String
    
    /// The time that the auction started
    public let startTime: String
    
    /// The time that the auction is scheduled to end
    public let endTime: String
    
    /// Whether or not the auction has been settled
    public let settled: Bool
    
    /// The auction bids
    public let bids: [Bid]
}

/// The auction's Bid
public struct Bid: Decodable {
    
    /// Bid transaction hash
    public let id: String
    
    /// Bid amount
    public let amount: String
}
