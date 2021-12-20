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
  
  /// The NSManagedObjectContext instance to be used for performing the operations.
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  /// A container that encapsulates the Core Data stack.
  private let persistentContainer: NSPersistentContainer
  
  /// Creates a container using the model named `dataModel` in the main bundle.
  public init(dataModel: String = "Nouns") {
    persistentContainer = NSPersistentContainer(name: dataModel)
    persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    persistentContainer.loadPersistentStores(completionHandler: { _, error in
      guard let error = error else { return }
      fatalError("💥 Couldn't load data model: \(error)")
    })
  }
  
  public func fetchNouns(limit: Int, cursor: Int, ascending: Bool) throws -> [Noun] {
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
    guard let managedObject = try NounManagedObject.fetch(in: viewContext, configuration: { fetchRequest in
      fetchRequest.predicate = NSPredicate(format: "id == %@", noun.id)
    }).first else {
      throw OffChainNounsRequestError.invalidData
    }
    
    viewContext.delete(managedObject)
    try viewContext.save()
  }
}
