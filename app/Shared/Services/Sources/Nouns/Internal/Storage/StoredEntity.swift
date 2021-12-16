//
//  AccountManagedObject.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import CoreData

/// <#Description#>
protocol StoredEntity: AnyObject {
  
  /// <#Description#>
  static var entity: NSEntityDescription { get }
  
  /// <#Description#>
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
      throw PersistenceStoreError.invalidEntityType
    }
    
    let request = NSFetchRequest<Self>(entityName: entityName)
    configuration?(request)
    return try context.fetch(request)
  }
}
