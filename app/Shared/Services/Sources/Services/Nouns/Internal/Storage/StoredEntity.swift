//
//  AccountManagedObject.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import CoreData

enum StoredEntityError: Error {
  case invalidEntityType
}

protocol StoredEntity: AnyObject {
  
  static var entity: NSEntityDescription { get }
  
  static var entityName: String? { get }
}

extension StoredEntity where Self: NSManagedObject {
  
  static var entity: NSEntityDescription {
    entity()
  }

  static var entityName: String? {
    entity.name
  }
  
  static func fetch(
    in context: NSManagedObjectContext,
    configuration: ((NSFetchRequest<Self>) -> Void)? = nil
  ) throws -> [Self] {
    guard let entityName = Self.entityName else {
      throw StoredEntityError.invalidEntityType
    }
    
    let request = NSFetchRequest<Self>(entityName: entityName)
    configuration?(request)
    return try context.fetch(request)
  }
}
