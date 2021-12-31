//
//  AccountManagedObject.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import CoreData

/// `Account Core Data` model object.
@objc(AccountManagedObject)
final class AccountManagedObject: NSManagedObject {
  @NSManaged var id: String
  @NSManaged var nouns: Set<NounManagedObject>?
}

extension AccountManagedObject: StoredEntity {
  
  static var entityName: String? {
    return "Account"
  }
  
  static func insert(
    into context: NSManagedObjectContext,
    account: Account
  ) throws -> Self {
    let managedObject: Self = try context.insertObject()
    managedObject.id = account.id
    return managedObject
  }
}

extension AccountManagedObject: CustomModelConvertible {

  var model: Account {
    Account(id: id)
  }
}
