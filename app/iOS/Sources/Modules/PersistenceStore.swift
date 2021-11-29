//
//  PersistenceStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-23.
//

import UIKit
import CoreData
import Combine
import SwiftUI

class PersistenceStore {
  static let shared = PersistenceStore()
  
  private var cancellable: Cancellable?
  
  let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Nouns")
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
  
  /// Creates and saves an NSManagedObject for a user-created Noun
  func saveCreatedNoun(
    name: String,
    glasses: String,
    head: String,
    body: String,
    accessory: String,
    background: Int32
  ) {
    
    let createdNoun = OfflineNoun(context: persistentContainer.viewContext)
    createdNoun.id = UUID()
    createdNoun.createdDate = Date()
    createdNoun.name = name
    createdNoun.body = body
    createdNoun.glasses = glasses
    createdNoun.head = head
    createdNoun.body = body
    createdNoun.accessory = accessory
    createdNoun.background = background
    
    // Save changes
    save()
  }
  
  func delete(_ noun: OfflineNoun) {
    persistentContainer.viewContext.delete(noun)
    save()
  }
  
  /// Saves changes to Core Data
  func save() {
    guard persistentContainer.viewContext.hasChanges else { return }

    try? persistentContainer.viewContext.save()
  }
}
