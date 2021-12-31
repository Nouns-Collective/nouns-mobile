//
//  OfflineNouns.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import CoreData

/// `OffChainNounsService` request error.
public enum OffChainNounsRequestError: Error {
  case invalidData
  case unableToLoadStore
}

/// Service allows interacting with the `Offline Nouns`.
public protocol OffChainNounsService {
  
  /// Fetches the list of Nouns from the persistence store.
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///   - ascending: Specify the order of the list returned.
  /// - Returns: a list of `Noun` type  instance or an error was encountered.
  func fetchNouns(limit: Int, cursor: Int, ascending: Bool) throws -> [Noun]
  
  /// Stores a given `Noun` into the persistence store.
  /// - Parameter noun: The noun to be persisted.
  func store(noun: Noun) throws
  
  /// Deletes a given `Noun` from the persistence store.
  /// - Parameter noun: The noun to be deleted.
  func delete(noun: Noun) throws
}

/// Concrete implementation of the `LocalNounsService` using `CoreData`.
public class CoreDataNounsProvider: OffChainNounsService {
  
  private static let modelName = "Nouns"
  
  /// The NSManagedObjectContext instance to be used for performing the operations.
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  /// A container that encapsulates the Core Data stack.
  private let persistentContainer: PersistentContainer
  
  /// Creates a container using the model named `dataModel` in the main bundle.
  public convenience init() {
    self.init(persistentContainer: .init(
      name: Self.modelName))
  }
  
  init(persistentContainer: PersistentContainer) {
      self.persistentContainer = persistentContainer
    
    persistentContainer.loadPersistentStores { _, error in
      guard let error = error else {
        return
      }
      fatalError("💥 Couldn't load data model: \(error)")
    }
  }
  
  public func fetchNouns(limit: Int = 20, cursor: Int = 0, ascending: Bool = true) throws -> [Noun] {
    try NounManagedObject.fetch(in: viewContext) { fetchRequest in
      fetchRequest.fetchLimit = limit
      fetchRequest.fetchOffset = cursor
      fetchRequest.sortDescriptors = [
        NSSortDescriptor(
          keyPath: \NounManagedObject.createdAt,
          ascending: ascending
        )
      ]
    }
    .map { $0.model }
  }
  
  public func store(noun: Noun) throws {
    _ = try NounManagedObject.insert(into: viewContext, noun: noun)
    try viewContext.save()
  }
  
  public func delete(noun: Noun) throws {
    let managedObjects = try NounManagedObject.fetch(
      in: viewContext,
      configuration: { fetchRequest in
      fetchRequest.predicate = NSPredicate(format: "id == %@", noun.id)
    })
    
    guard let managedObject = managedObjects.first else {
      throw OffChainNounsRequestError.invalidData
    }
    
    viewContext.delete(managedObject)
    try viewContext.save()
  }
}

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
