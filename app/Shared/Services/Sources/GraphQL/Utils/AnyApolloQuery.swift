//
//  AnyApolloQuery.swift
//  Services
//
//  Created by Ziad Tamim on 24.10.21.
//

import Foundation
import Apollo
import SwiftUI

/// Type erasure for Apollo `GraphQLQuery`
public class AnyApolloQuery<Data: GraphQLSelectionSet> {
  let _box: _AnyApolloQueryBoxBase<Data>
  
  public init<I: GraphQLQuery>(_ base: I) where I.Data == Data {
    self._box = _ApolloQueryBox(base)
  }
}

internal class _AnyApolloQueryBoxBase<Data: GraphQLSelectionSet>: GraphQLQuery {
  
  var operationType: GraphQLOperationType { _abstract() }
  var operationDefinition: String { _abstract() }
  var operationIdentifier: String? { _abstract() }
  var operationName: String { _abstract() }
  var queryDocument: String { _abstract() }
  var variables: GraphQLMap? { _abstract() }
}

internal final class _ApolloQueryBox<Base: GraphQLQuery>: _AnyApolloQueryBoxBase<Base.Data> {

  internal init(_ base: Base) { self._base = base }
  
  override var operationType: GraphQLOperationType { self._base.operationType }
  override var operationDefinition: String { self._base.operationDefinition }
  override var operationIdentifier: String? { self._base.operationIdentifier }
  override var operationName: String { self._base.operationName }
  override var queryDocument: String { self._base.queryDocument }
  override var variables: GraphQLMap? { self._base.variables }
  
  internal var _base: Base
}

extension AnyApolloQuery: GraphQLQuery {
  
  public var operationType: GraphQLOperationType {
    self._box.operationType
  }
  
  public var operationDefinition: String {
    self._box.operationDefinition
  }
  
  public var operationIdentifier: String? {
    self._box.operationIdentifier
  }
  
  public var operationName: String {
    self._box.operationName
  }
  
  public var queryDocument: String {
    self._box.queryDocument
  }
  
  public var variables: GraphQLMap? {
    self._box.variables
  }
}

internal func _abstract(
  file: StaticString = #file,
  line: UInt = #line
) -> Never {
  fatalError("Method must be overridden", file: file, line: line)
}

