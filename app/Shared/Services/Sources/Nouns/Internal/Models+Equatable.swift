//
//  Models+Equatable.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

extension Noun: Equatable {
    
    public static func == (lhs: Noun, rhs: Noun) -> Bool {
        lhs.id == rhs.id &&
        lhs.owner == rhs.owner &&
        lhs.seed == rhs.seed
    }
}

extension Seed: Equatable {
    
    public static func == (lhs: Seed, rhs: Seed) -> Bool {
        lhs.background == rhs.background &&
        lhs.head == rhs.head &&
        lhs.body == rhs.body &&
        lhs.accessory == rhs.accessory &&
        lhs.glasses == rhs.glasses
    }
}

extension Trait: Equatable {
    
    public static func == (lhs: Trait, rhs: Trait) -> Bool {
        lhs.assetImage == rhs.assetImage &&
        lhs.rleData == rhs.rleData
    }
}

extension Account: Equatable {
    
    public static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id
    }
}

extension Vote: Equatable {
    
    public static func == (lhs: Vote, rhs: Vote) -> Bool {
        lhs.supportDetailed == rhs.supportDetailed &&
        lhs.proposal == rhs.proposal
    }
}

extension Proposal: Equatable {
    
    public static func == (lhs: Proposal, rhs: Proposal) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.status == rhs.status
    }
}

extension Auction: Equatable {
    
    public static func == (lhs: Auction, rhs: Auction) -> Bool {
        lhs.id == rhs.id &&
        lhs.noun == rhs.noun &&
        lhs.amount == rhs.amount &&
        lhs.startTime == rhs.startTime &&
        lhs.endTime == rhs.endTime &&
        lhs.settled == rhs.settled &&
        lhs.bids == rhs.bids
    }
}

extension Bid: Equatable {
    
    public static func == (lhs: Bid, rhs: Bid) -> Bool {
        lhs.id == rhs.id &&
        lhs.amount == rhs.amount
    }
}
