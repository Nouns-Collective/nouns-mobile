//
//  OfflineNouns.swift
//  
//
//  Created by Ziad Tamim on 16.12.21.
//

import CoreData

/// <#Description#>
public enum OnfflineNounsError: Error {
  case invalidData
}

/// <#Description#>
public protocol LocalNounsService {
  
  /// <#Description#>
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///   - ascending: <#ascending description#>
  /// - Returns: <#description#>
  func fetchNouns(limit: Int, cursor: Int, ascending: Bool) throws -> [Noun]
  
  /// <#Description#>
  /// - Parameter noun: <#noun description#>
  func store(noun: Noun) throws

  /// <#Description#>
  /// - Parameter noun: <#noun description#>
  func delete(noun: Noun) throws
}

/// <#Description#>
public class CoreDataNounsProvider: LocalNounsService {
  
  /// The NSManagedObjectContext instance to be used for performing the operations.
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  /// A container that encapsulates the Core Data stack.
  private let persistentContainer: NSPersistentContainer
  
  /// <#Description#>
  /// - Parameter dataModel: <#dataModel description#>
  init(dataModel: String = "Nouns") async throws {
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
  
  /// <#Description#>
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///   - ascending: <#ascending description#>
  /// - Returns: <#description#>
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
  
  /// <#Description#>
  /// - Parameter noun: <#noun description#>
  public func store(noun: Noun) throws {
    _ = try NounManagedObject.insert(into: viewContext, noun: noun)
    try viewContext.save()
  }
  
  /// <#Description#>
  /// - Parameter noun: <#noun description#>
  public func delete(noun: Noun) throws {
    guard let managedObject = try NounManagedObject.fetch(in: viewContext, configuration: { fetchRequest in
      fetchRequest.predicate = NSPredicate(format: "id == %@", noun.id)
    }).first else {
      throw OnfflineNounsError.invalidData
    }
    
    viewContext.delete(managedObject)
    try viewContext.save()
  }
}
