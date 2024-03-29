// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import CoreData

/// `OffChainNounsService` request error.
public enum OffChainNounsRequestError: Error {
  case invalidData
  case unableToLoadStore
  case noContext
  case invalidEntityType
}

/// Service allows interacting with the `Offline Nouns`.
public protocol OffChainNounsService {
  
  /// Fetches the list of Nouns from the persistence store.
  /// - Parameters:
  ///   - ascending: Specify the order of the list returned.
  /// - Returns: a list of `Noun` type  instance or an error was encountered.
  func fetchNouns(ascending: Bool) throws -> [Noun]
  
  /// Listens to changes in the offline nouns store
  /// - Parameters:
  ///   - ascending: Specify the order of the list returned.
  /// - Returns: a list of `Noun` type  instance or an error was encountered, which is returned everytime an addition, deletion or change is observed in the offline noun store.
  func nounsStoreDidChange(ascendingOrder: Bool) -> AsyncThrowingStream<[Noun], Error>
    
  /// Stores a given `Noun` into the persistence store.
  /// - Parameter noun: The noun to be persisted.
  func store(noun: Noun) throws
  
  /// Deletes a given `Noun` from the persistence store.
  /// - Parameter noun: The noun to be deleted.
  func delete(noun: Noun) throws
}

/// Concrete implementation of the `LocalNounsService` using `CoreData`.
public class CoreDataOffChainNouns: OffChainNounsService {
  
  /// The name of the data model.
  private static let modelName = "Nouns"
  
  /// The `NSManagedObjectContext` instance to be used for performing the operations.
  private var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  /// A container that encapsulates the Core Data stack.
  private let persistentContainer: PersistentContainer
  
  /// Reference to the store watcher for new `Nouns` entities Changes.
  private var autoStoreFetcher: AutoStoreFetcher<NounManagedObject>?
  
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
  
  public func nounsStoreDidChange(ascendingOrder: Bool = true) -> AsyncThrowingStream<[Noun], Error> {
    AsyncThrowingStream { [weak self] continuation in
      guard let self = self else { return }
      
      do {
        if autoStoreFetcher == nil {
          autoStoreFetcher = try AutoStoreFetcher<NounManagedObject>(
            viewContext: viewContext,
            sortKeyPath: \NounManagedObject.createdAt,
            ascendingOrder: ascendingOrder
          )
        }
        
        let fetchedObjectsCancellable = self.autoStoreFetcher?.$fetchedObjects
          .map { $0.map { $0.model } }
          .sink { nouns in
            continuation.yield(nouns)
          }
        
        continuation.onTermination = { @Sendable _ in
          self.autoStoreFetcher = nil
          fetchedObjectsCancellable?.cancel()
        }
        
      } catch {
        continuation.finish(throwing: error)
      }
    }
  }
  
  public func fetchNouns(ascending: Bool = true) throws -> [Noun] {
    try NounManagedObject.fetch(in: viewContext) { fetchRequest in
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
      }
    )
    
    guard let managedObject = managedObjects.first else {
      throw OffChainNounsRequestError.invalidData
    }
    
    viewContext.delete(managedObject)
    try viewContext.save()
  }
}
