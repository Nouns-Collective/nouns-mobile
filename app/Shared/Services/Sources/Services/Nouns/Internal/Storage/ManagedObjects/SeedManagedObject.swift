//
//  SeedManagedObject.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import CoreData

/// `Seed Core Data` model object.
@objc(SeedManagedObject)
final class SeedManagedObject: NSManagedObject {
  @NSManaged var head: Int32
  @NSManaged var body: Int32
  @NSManaged var glasses: Int32
  @NSManaged var accessory: Int32
  @NSManaged var background: Int32
  @NSManaged var noun: NounManagedObject
}

extension SeedManagedObject: StoredEntity {
  
  static var entityName: String? {
    return "Seed"
  }
  
  static func insert(
    into context: NSManagedObjectContext,
    seed: Seed
  ) throws -> Self {
    let managedObject: Self = try context.insertObject()
    managedObject.head = Int32(seed.head)
    managedObject.body = Int32(seed.body)
    managedObject.glasses = Int32(seed.glasses)
    managedObject.accessory = Int32(seed.accessory)
    managedObject.background = Int32(seed.background)
    return managedObject
  }
}

extension SeedManagedObject: CustomModelConvertible {

  var model: Seed {
    Seed(
      background: Int(background),
      glasses: Int(glasses),
      head: Int(head),
      body: Int(body),
      accessory: Int(accessory))
  }
}
