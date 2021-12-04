//
//  NounsStorageModels.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import CoreData

protocol AuctionPersistenceStore {
    /// Fetches stored Auctions.
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Auction], Error>
    
    // Insert an auction on the persistance store.
    func insert(auction: Auction) -> Result<Bool, Error>
}

final class AuctionCoreData: AuctionPersistenceStore {
    private let store: CoreDataStore<AuctionManagedObject>
    
    init(context: NSManagedObjectContext) {
        store = CoreDataStore(managedObjectContext: context)
    }
    
    /// Fetches an Auction using a predicate.
    /// - Parameter predicate: of the fetch request.
    func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> Result<[Auction], Error> {
        let result = store.fetch(predicate: predicate, sortDescriptors: sortDescriptors)
        switch result {
        case .success(let objects):
            let auctions = objects.map { $0.model }
            return .success(auctions)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func insert(auction: Auction) -> Result<Bool, Error> {
        switch store.insert() {
        case .success(let object):
            // Update the auction properties.
            object.id = auction.id
            object.amount = auction.amount
            object.startTime = auction.startTime
            object.endTime = auction.endTime
            object.settled = auction.settled
//            object.noun: NounManagedObject
            return .success(true)
            
        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }
}

protocol ModelConvertible {
    /// The domain model type.
    associatedtype ModelType
    
    /// Transform any entity to the domain model type.
    var model: ModelType { get }
}

final class AuctionManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var startTime: String
    @NSManaged var endTime: String
    @NSManaged var settled: Bool
    @NSManaged var noun: NounManagedObject
}

extension AuctionManagedObject: ModelConvertible {
    
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

final class NounManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var owner: AccountManagedObject
    @NSManaged var seed: SeedManagedObject
    @NSManaged var auction: AuctionManagedObject?
}

extension NounManagedObject: ModelConvertible {
    
    var model: Noun {
        Noun(id: id, owner: owner.model, seed: seed.model)
    }
}

final class SeedManagedObject: NSManagedObject {
    @NSManaged var head: Int32
    @NSManaged var body: Int32
    @NSManaged var glasses: Int32
    @NSManaged var accessory: Int32
    @NSManaged var background: Int32
    @NSManaged var noun: NounManagedObject
}

extension SeedManagedObject: ModelConvertible {
    
    var model: Seed {
        Seed(
            background: Int(background),
            glasses: Int(glasses),
            head: Int(head),
            body: Int(body),
            accessory: Int(accessory))
    }
}

final class AccountManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var nouns: Set<NounManagedObject>?
    @NSManaged var bid: Set<BidManagedObject>?
}

extension AccountManagedObject: ModelConvertible {
    
    var model: Account {
        Account(id: id)
    }
}

final class VoteManagedObject: NSManagedObject {
    @NSManaged var supportedDetailed: Int16
    @NSManaged var proposal: ProposalManagedObject
}

extension VoteManagedObject: ModelConvertible {
    
    var model: Vote {
        guard let supportedDetailed = VoteSupportDetailed(rawValue: Int(supportedDetailed)) else {
            fatalError("\(#function) couldn't a case for the vote's supported detailed.")
        }
        
        return Vote(
            supportDetailed: supportedDetailed,
            proposal: proposal.model)
    }
}

final class ProposalManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var desc: String
    @NSManaged var status: String
    @NSManaged var vote: Set<VoteManagedObject>?
}

extension ProposalManagedObject: ModelConvertible {
    
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

final class BidManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var amount: String
    @NSManaged var blockTimestamp: String
    @NSManaged var bidder: AccountManagedObject
}

extension BidManagedObject: ModelConvertible {
    
    var model: Bid {
        Bid(id: id,
            amount: amount,
            blockTimestamp: blockTimestamp,
            bidder: bidder.model)
    }
}
