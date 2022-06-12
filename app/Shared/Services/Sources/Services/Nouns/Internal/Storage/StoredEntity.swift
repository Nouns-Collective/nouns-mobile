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
