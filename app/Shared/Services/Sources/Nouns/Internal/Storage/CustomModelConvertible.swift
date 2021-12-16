//
//  ModelConvertible.swift
//  
//
//  Created by Ziad Tamim on 04.12.21.
//

import Foundation

/// Converts  `Store Model`.
protocol CustomModelConvertible {
  
  /// The domain model type.
  associatedtype ModelType
  
  /// Transform any entity to the domain model type.
  var model: ModelType { get }
}
