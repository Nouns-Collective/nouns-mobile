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
