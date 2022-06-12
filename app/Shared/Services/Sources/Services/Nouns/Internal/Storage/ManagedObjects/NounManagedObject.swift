// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
