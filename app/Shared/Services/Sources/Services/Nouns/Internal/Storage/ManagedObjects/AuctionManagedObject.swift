//
//  AuctionManagedObject.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import CoreData

/// `Auction Core Data` model object.
@objc(AuctionManagedObject)
final class AuctionManagedObject: NSManagedObject {
  @NSManaged var id: String
  @NSManaged var amount: String
  @NSManaged var startTime: String
  @NSManaged var endTime: String
  @NSManaged var settled: Bool
  @NSManaged var noun: NounManagedObject
}

extension AuctionManagedObject: StoredEntity {
  
  static var entityName: String? {
    return "Auction"
  }
}
