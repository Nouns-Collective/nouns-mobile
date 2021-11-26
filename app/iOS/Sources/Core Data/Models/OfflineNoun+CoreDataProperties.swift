//
//  OfflineNoun+CoreDataProperties.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//
//

import Foundation
import CoreData

extension OfflineNoun {
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<OfflineNoun> {
    return NSFetchRequest<OfflineNoun>(entityName: "OfflineNoun")
  }
  
  @NSManaged public var accessory: String?
  @NSManaged public var background: [String]?
  @NSManaged public var body: String?
  @NSManaged public var createdDate: Date?
  @NSManaged public var glasses: String?
  @NSManaged public var head: String?
  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  
}

extension OfflineNoun: Identifiable {
  
}
