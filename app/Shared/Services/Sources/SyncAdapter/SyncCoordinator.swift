//
//  SyncCoordinator.swift
//  
//
//  Created by Ziad Tamim on 14.12.21.
//

import Foundation
import CoreData

final class SyncCoordinator {
    let viewContext: NSManagedObjectContext
    let syncContext: NSManagedObjectContext
    let syncGroup: DispatchGroup = DispatchGroup()
    
    /// Nouns availabe on the eth network
    let nounsProvider: Nouns
    
    init(
        container: NSPersistentContainer,
        nouns: Nouns = TheGraphNounsProvider()
    ) {
        viewContext = container.viewContext
        syncContext = container.newBackgroundContext()
        syncContext.name = "wtf.nouns.syncCoordinator"
        syncContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        nounsProvider = nouns
    }
}
