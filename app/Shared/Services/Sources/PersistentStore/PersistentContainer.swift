//
//  PersistentContainer.swift
//  
//
//  Created by Ziad Tamim on 31.12.21.
//

import CoreData

final class PersistentContainer: NSPersistentContainer {
  
  init(name: String, bundle: Bundle = .module, inMemory: Bool = false) {
    guard let mom = NSManagedObjectModel.mergedModel(
      from: [bundle]
    ) else {
      fatalError("💥 Couldn't load data model")
    }
    
    super.init(name: name, managedObjectModel: mom)
    configureDefaults(inMemory: inMemory)
  }
  
  private func configureDefaults(inMemory: Bool = false) {
    viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    guard let storeDescription = persistentStoreDescriptions.first else {
      return
    }
    
    storeDescription.shouldAddStoreAsynchronously = true
    if inMemory {
      storeDescription.url = URL(fileURLWithPath: "/dev/null")
      storeDescription.shouldAddStoreAsynchronously = false
    }
  }
}
