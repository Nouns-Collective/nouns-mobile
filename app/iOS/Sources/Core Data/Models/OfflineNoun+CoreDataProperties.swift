//
//  OfflineNoun+CoreDataProperties.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-23.
//
//

import Foundation
import CoreData

extension OfflineNoun {
  
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<OfflineNoun> {
    return NSFetchRequest<OfflineNoun>(entityName: "OfflineNoun")
  }
  
  /// The unique ID of the Noun
  @NSManaged public var id: UUID
  
  /// The date the offline noun was created
  @NSManaged public var createdDate: Date
  
  /// The user-defined name of the noun
  @NSManaged public var name: String?
  
  /// The background asset image name
  @NSManaged public var background: String?
  
  /// The glasses asset image name
  @NSManaged public var glasses: String?
  
  /// The head asset image name
  @NSManaged public var head: String?
  
  /// The body asset image name
  @NSManaged public var body: String?
  
  /// The accessory asset image name
  @NSManaged public var accessory: String?
}

extension OfflineNoun: Identifiable {}
