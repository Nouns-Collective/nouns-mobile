//
//  ModelConvertible.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import Foundation

protocol CustomModelConvertible {
    /// The domain model type.
    associatedtype ModelType
    
    /// Transform any entity to the domain model type.
    var model: ModelType { get }
}

extension NounDB: CustomModelConvertible {
    
    var model: Noun {
        Noun(id: id, owner: owner.model, seed: seed.model)
    }
}

extension SeedDB: CustomModelConvertible {
    
    var model: Seed {
        Seed(
            background: Int(background),
            glasses: Int(glasses),
            head: Int(head),
            body: Int(body),
            accessory: Int(accessory))
    }
}

extension DBAccount: CustomModelConvertible {
    
    var model: Account {
        Account(id: id)
    }
}

extension AuctionDB: CustomModelConvertible {
    
    var model: Auction {
        Auction(
            id: id,
            noun: noun.model,
            amount: amount,
            startTime: startTime,
            endTime: endTime,
            settled: settled)
    }
}

extension BidDB: CustomModelConvertible {
    
    var model: Bid {
        Bid(id: id,
            amount: amount,
            blockTimestamp: blockTimestamp,
            bidder: bidder.model)
    }
}

extension ProposalDB: CustomModelConvertible {
    
    var model: Proposal {
        guard let status = ProposalStatus(rawValue: status) else {
            fatalError("\(#function) couldn't a case for Proposal's status.")
        }
        
        return Proposal(
            id: id,
            title: title,
            description: desc,
            status: status)
    }
}

extension VoteDB: CustomModelConvertible {
    
    var model: Vote {
        guard let supportedDetailed = VoteSupportDetailed(rawValue: Int(supportedDetailed)) else {
            fatalError("\(#function) couldn't a case for the vote's supported detailed.")
        }
        
        return Vote(
            supportDetailed: supportedDetailed,
            proposal: proposal.model)
    }
}


