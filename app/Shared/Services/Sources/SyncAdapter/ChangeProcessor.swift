//
//  ChangeProcessor.swift
//  
//
//  Created by Ziad Tamim on 14.12.21.
//

import Foundation
import CoreData

enum CloudEntityChange<T: CloudEntity> {
    case insert(T)
}

public protocol CloudEntity {}

protocol ChangeProcessor {
    
    func processCloudChanges(in context: ChangeProcessContext)
    
    func fetchCloudEntities(in context: ChangeProcessContext, limit: Int, cursor: Int) async throws 
}

protocol ChangeProcessContext {
    
    var context: NSManagedObjectContext { get }
    
    var cloud: CloudNounsService { get }
}
