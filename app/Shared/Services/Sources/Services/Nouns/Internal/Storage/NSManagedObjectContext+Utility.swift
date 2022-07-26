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

import CoreData

extension NSManagedObjectContext {
  
  func insertObject<A: NSManagedObject>() throws -> A where A: StoredEntity {
    guard
      let entityName = A.entityName,
      let entity = NSEntityDescription.insertNewObject(
        forEntityName: entityName,
        into: self
      ) as? A else {
        throw StoredEntityError.invalidEntityType
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
