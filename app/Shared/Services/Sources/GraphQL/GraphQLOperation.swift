//
//  GraphQLQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

public enum GraphQLOperationType: String, CodingKey {
  
  /// Sstandard HTTP methods.
  case query
  
  /// Realtime operation based on websockets.
  case subscription
}

public protocol GraphQLOperation: Encodable {
  
  /// Define the operation entry-points for the API.
  var operationType: GraphQLOperationType { get }
  
  /// The raw GraphQL definition of this operation.
  var operationDefinition: String { get }
  
  ///
  var url: URL { get }
}

public protocol GraphQLQuery: GraphQLOperation {}
extension GraphQLQuery {
  public var operationType: GraphQLOperationType { .query }
}

public protocol GraphQLSubscription: GraphQLOperation {}
extension GraphQLSubscription {
  public var operationType: GraphQLOperationType { .subscription }
}

extension GraphQLOperation {
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: GraphQLOperationType.self)
    try container.encode(operationDefinition, forKey: operationType)
  }
  
  public func encode() throws -> Data {
    try JSONEncoder().encode(self)
  }
}
