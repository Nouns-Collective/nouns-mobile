//
//  AccountManagedObject.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import CoreData

final class AccountManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var nouns: Set<NounManagedObject>?
    @NSManaged var bid: Set<BidManagedObject>?
}

final class AuctionManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var startTime: String
    @NSManaged var endTime: String
    @NSManaged var settled: Bool
    @NSManaged var noun: NounManagedObject
}

final class NounManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var owner: AccountManagedObject
    @NSManaged var seed: SeedManagedObject
    @NSManaged var auction: AuctionManagedObject?
}

final class SeedManagedObject: NSManagedObject {
    @NSManaged var head: Int32
    @NSManaged var body: Int32
    @NSManaged var glasses: Int32
    @NSManaged var accessory: Int32
    @NSManaged var background: Int32
    @NSManaged var noun: NounManagedObject
}

final class ProposalManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var status: String
    @NSManaged var vote: Set<VoteManagedObject>?
}

final class VoteManagedObject: NSManagedObject {
    @NSManaged var supportedDetailed: Int16
    @NSManaged var proposal: ProposalManagedObject
}

final class BidManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var blockTimestamp: String
    @NSManaged var bidder: AccountManagedObject
}
