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
  
  /// The unique ID of the Noun
  @NSManaged public var id: UUID
    
  /// The user-defined name of the noun
  @NSManaged public var name: String
  
  /// The date the offline noun was created
  @NSManaged public var createdDate: Date
  
  /// The accessory asset image name
  @NSManaged public var accessory: String
  
  /// The body asset image name
  @NSManaged public var body: String
  
  /// The glasses asset image name
  @NSManaged public var glasses: String
  
  /// The head asset image name
  @NSManaged public var head: String

  /// The background of the noun, as an array of hex colors to represent a linear gradient
  @NSManaged public var background: [String]
  
}

extension OfflineNoun: Identifiable {
  
}

extension OfflineNoun {
  
  static var defaultSortDescriptors: [NSSortDescriptor] {
    [
      NSSortDescriptor(key: #keyPath(createdDate), ascending: false),
    ]
  }
}
