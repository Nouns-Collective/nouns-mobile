//
//  PersistenceStore.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-23.
//

import CoreData

/// Enum for CoreData related errors
public enum CoreDataError: Error {
    case invalidManagedObjectType
}

public protocol PersistenceStore {
    /// The entity managed by the repository.
    associatedtype Entity
    
    /// Gets an array of entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    func fetch(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
    
    /// Insert an entity.
    func insert() -> Result<Entity, Error>
    
    /// Deletes an entity.
    /// - Parameter entity: The entity to be deleted.
    func delete(_ entity: Entity) -> Result<Bool, Error>
    
    /// Saves occured changes.
    func save() throws
}

public class CoreDataStore<T: NSManagedObject>: PersistenceStore {
    public typealias Entity = T

    /// The NSManagedObjectContext instance to be used for performing the operations.
    private var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// A container that encapsulates the Core Data stack.
    private let persistentContainer: NSPersistentContainer

    /// Abstracts & simplifies the creation and management of the Core Data stack
    /// by handling the creation of the managed object model.
    /// - Parameters:
    ///   - dataModel: the name the persistent store.
    ///   - mergePolicy: The merge policy of the context
    ///   - completionHandler: will be called if there is an error in the loading of the persistent stores.
    public init(
        dataModel: String,
        mergePolicy: NSMergePolicy = .mergeByPropertyObjectTrump,
        completionHandler: ((Error) -> Void)? = nil
    ) {
        persistentContainer = NSPersistentContainer(name: dataModel)
        persistentContainer.viewContext.mergePolicy = mergePolicy
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            guard let error = error else {
                return
            }
            completionHandler?(error)
        })
    }
    
    /// Gets an array of NSManagedObject entities.
    /// - Parameters:
    ///   - predicate: The predicate to be used for fetching the entities.
    ///   - sortDescriptors: The sort descriptors used for sorting the returned array of entities.
    /// - Returns: A result consisting of either an array of NSManagedObject entities or an Error.
    public func fetch(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?
    ) -> Result<[Entity], Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            // Perform the fetch request
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }
    
    /// Creates a NSManagedObject entity.
    /// - Returns: A result consisting of either a NSManagedObject entity or an Error.
    public func insert() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(
            forEntityName: className,
            into: managedObjectContext
        ) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }
    
    /// Deletes a NSManagedObject entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    /// - Returns: A result consisting of either a Bool set to true or an Error.
    public func delete(_ entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
    /// Saves occured changes.
    public func save() throws {
        guard managedObjectContext.hasChanges else {
            return
        }
        try managedObjectContext.save()
    }
}
