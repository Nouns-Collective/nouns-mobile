//
//  NounManagedObject.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import CoreData

/// `Noun Core Data` model object.
@objc(NounManagedObject)
final class NounManagedObject: NSManagedObject {
  @NSManaged var id: String
  @NSManaged var name: String
  @NSManaged var createdAt: Date
  @NSManaged var updatedAt: Date
  @NSManaged var owner: AccountManagedObject
  @NSManaged var seed: SeedManagedObject
  @NSManaged var auction: AuctionManagedObject?
}

extension NounManagedObject: StoredEntity {
  
  static var entityName: String? {
    return "Noun"
  }
  
  static func insert(
    into context: NSManagedObjectContext,
    noun: Noun
  ) throws -> Self {
    let managedObject: Self = try context.insertObject()
    managedObject.id = noun.id
    managedObject.name = noun.name
    managedObject.createdAt = noun.createdAt
    managedObject.updatedAt = noun.updatedAt
    
    managedObject.owner = try AccountManagedObject.insert(
      into: context,
      account: noun.owner
    )
    
    managedObject.seed = try SeedManagedObject.insert(
      into: context,
      seed: noun.seed
    )
    
    return managedObject
  }
}

extension NounManagedObject: CustomModelConvertible {

  var model: Noun {
    Noun(
      id: id,
      name: name,
      owner: owner.model,
      seed: seed.model,
      createdAt: createdAt,
      updatedAt: updatedAt
    )
  }
}