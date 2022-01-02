//
//  AutoStoreFetcher.swift
//  
//
//  Created by Ziad Tamim on 01.01.22.
//

import CoreData

enum AutoStoreFetcherError: Error {
  case invalidEntityType
  case accessObjectsPrecedeFetch
}

class AutoStoreFetcher<T>: NSObject, NSFetchedResultsControllerDelegate where T: NSManagedObject, T: StoredEntity {
  /// The results of the fetch.
  @Published var fetchedObjects = [T]()
  
  /// Manages the results of a Core Data fetch request and to publish data.
  private let fetchedResultsController: NSFetchedResultsController<T>
  
  init<Root, Value>(viewContext: NSManagedObjectContext, sortKeyPath: KeyPath<Root, Value>, ascendingOrder: Bool = false) throws {
    guard let entityName = T.entityName else {
      throw AutoStoreFetcherError.invalidEntityType
    }
    
    let fetchRequest = NSFetchRequest<T>(entityName: entityName)
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(
        keyPath: sortKeyPath,
        ascending: ascendingOrder
      )
    ]
    
    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    
    super.init()
    
    // Notified when the result set changes.
    fetchedResultsController.delegate = self
    
    // Initial objects's fetch from the store.
    try fetchedResultsController.performFetch()
    try publishFetchedObjects()
  }
  
  /// Publishs the fetched objects retrieved from the store.
  private func publishFetchedObjects() throws {
    guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
      throw AutoStoreFetcherError.accessObjectsPrecedeFetch
    }
    
    self.fetchedObjects = fetchedObjects
  }
  
  /// Describes the methods that will be called by the associated fetched results
  /// controller when the fetch results have changed.
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    try? publishFetchedObjects()
  }
  
  deinit {
    print("======")
  }
}
