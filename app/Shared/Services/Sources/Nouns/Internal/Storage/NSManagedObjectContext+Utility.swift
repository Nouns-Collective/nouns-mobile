//
//  File.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import CoreData

extension NSManagedObjectContext {
  
  func insertObject<A: NSManagedObject>() throws -> A where A: StoredEntity {
    guard
      let entityName = A.entityName,
      let entity = NSEntityDescription.insertNewObject(
        forEntityName: entityName,
        into: self
      ) as? A else {
        throw PersistenceStoreError.invalidEntityType
      }
    
    return entity
  }
  
  func performChanges(_ block: @escaping () -> Void) async throws {
    try await perform {
      block()
      _ = try self.save()
    }
  }
}
