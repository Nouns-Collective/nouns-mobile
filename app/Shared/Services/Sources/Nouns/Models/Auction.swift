//
//  Auction.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

/// The Auction
public struct Auction: Decodable {
    
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
}
