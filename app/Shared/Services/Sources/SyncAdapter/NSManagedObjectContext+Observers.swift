//
//  NSManagedObjectContext+Observers.swift
//  
//
//  Created by Ziad Tamim on 15.12.21.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
  
  func performMergeChanges(from notification: Notification) async {
    await perform {
      self.mergeChanges(fromContextDidSave: notification)
    }
  }
}
