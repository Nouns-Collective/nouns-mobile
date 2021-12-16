//
//  OfflineNouns.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import CoreData

/// `LocalNounsService` request error.
public enum LocalNounsRequestError: Error {
  case invalidData
}

/// Service allows interacting with the `Offline Nouns`.
public protocol LocalNounsService {
  
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
public class CoreDataNounsProvider: LocalNounsService {
  
  /// The NSManagedObjectContext instance to be used for performing the operations.
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  /// A container that encapsulates the Core Data stack.
  private let persistentContainer: NSPersistentContainer
  
  /// Creates a container using the model named `dataModel` in the main bundle.
  public init(dataModel: String = "Nouns") async throws {
    persistentContainer = NSPersistentContainer(name: dataModel)
    persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      persistentContainer.loadPersistentStores(completionHandler: { _, error in
        guard let error = error else {
          return continuation.resume(with: .success(()))
        }
        continuation.resume(throwing: error)
      })
    }
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
      throw LocalNounsRequestError.invalidData
    }
    
    viewContext.delete(managedObject)
    try viewContext.save()
  }
}
