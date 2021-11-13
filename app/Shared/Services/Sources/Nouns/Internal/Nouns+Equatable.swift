//
//  Nouns+Equatable.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

extension Noun: Equatable {
    
    public static func == (lhs: Noun, rhs: Noun) -> Bool {
        lhs.id == rhs.id &&
        lhs.owner == rhs.owner
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
