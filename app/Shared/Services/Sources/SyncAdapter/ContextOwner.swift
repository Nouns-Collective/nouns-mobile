//
//  ContextOwner.swift
//  
//
//  Created by Ziad Tamim on 15.12.21.
//

import Foundation
import CoreData

/// Implements the integration with persistence store change notifications.
protocol ContextOwner: AnyObject {
  
  /// The view managed object context.
  var viewContext: NSManagedObjectContext { get }
  
  /// The managed object context that is used to perform synchronization with the backend.
  var syncContext: NSManagedObjectContext { get }
  
  /// This group tracks any outstanding work.
  var syncGroup: DispatchGroup { get }
}

extension ContextOwner {
  
  func observeContext() async {
    for await notification in NotificationCenter.default.notifications(
      named: .NSManagedObjectContextDidSave,
      object: syncContext
    ) {
      await viewContext.performMergeChanges(from: notification)
    }
    
  }
}
