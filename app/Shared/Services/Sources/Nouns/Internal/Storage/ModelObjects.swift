//
//  AccountManagedObject.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import CoreData

final class DBAccount: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var nouns: Set<NounDB>?
    @NSManaged var bid: Set<BidDB>?
}

final class AuctionDB: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var startTime: String
    @NSManaged var endTime: String
    @NSManaged var settled: Bool
    @NSManaged var noun: NounDB
}

final class NounDB: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var owner: DBAccount
    @NSManaged var seed: SeedDB
    @NSManaged var auction: AuctionDB?
}

final class SeedDB: NSManagedObject {
    @NSManaged var head: Int32
    @NSManaged var body: Int32
    @NSManaged var glasses: Int32
    @NSManaged var accessory: Int32
    @NSManaged var background: Int32
    @NSManaged var noun: NounDB
}

final class ProposalDB: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var status: String
    @NSManaged var vote: Set<VoteDB>?
}

final class VoteDB: NSManagedObject {
    @NSManaged var supportedDetailed: Int16
    @NSManaged var proposal: ProposalDB
}

final class BidDB: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var blockTimestamp: String
    @NSManaged var bidder: DBAccount
}
