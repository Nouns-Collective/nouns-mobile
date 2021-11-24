//
//  PersistenceStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-23.
//

import UIKit
import CoreData
import Combine

class PersistenceStore {
  
  private var cancellable: Cancellable?
  
  let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Nouns")
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  init() {
    // A notification that posts when the app is no longer active and loses focus.
    // In this case, it saves all changes made to the view context
    cancellable = NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .sink(receiveValue: { [weak self] _ in
              guard let self = self else { return }
              if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
              }
            })
  }
  
  /// Saves changes to Core Data
  func save() {
    try? persistentContainer.viewContext.save()
  }
}
