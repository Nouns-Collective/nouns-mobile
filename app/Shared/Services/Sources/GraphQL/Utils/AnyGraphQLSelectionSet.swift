//
//  AnyGraphQLSelectionSet.swift
//  Services
//
//  Created by Ziad Tamim on 24.10.21.
//

import Foundation
import Apollo
import UIKit

/// Type erasure for Apollo `GraphQLSelectionSet`
public final class AnyGraphQLSelectionSet {
  let _box: GraphQLSelectionSet
  let _boxType: GraphQLSelectionSet.Type
  
  public init<I: GraphQLSelectionSet>(_ base: I, baseType: I.Type) {
    self._box = _AnyGraphQLSelectionSetBox(base)
    self._boxType = baseType
  }
}

internal class _AnyGraphQLSelectionSetBoxBase: GraphQLSelectionSet {

  class var selections: [GraphQLSelection] { _abstract() }

  var resultMap: ResultMap { _abstract() }
  required init(unsafeResultMap: ResultMap) { }
}

internal final class _AnyGraphQLSelectionSetBox<Base: GraphQLSelectionSet>: _AnyGraphQLSelectionSetBoxBase {

  init(_ base: Base) {
    _base = base
    super.init(unsafeResultMap: _base.resultMap)
  }

  required init(unsafeResultMap: ResultMap) {
    fatalError("init(unsafeResultMap:) has not been implemented")
  }

  class override var selections: [GraphQLSelection] { Base.selections }

  override var resultMap: ResultMap { self._base.resultMap }

  internal var _base: Base
}

extension AnyGraphQLSelectionSet: GraphQLSelectionSet {
  
  convenience public init(unsafeResultMap: ResultMap) {
    fatalError("init(unsafeResultMap:) has not been implemented")
  }

  public static var selections: [GraphQLSelection] {
    _AnyGraphQLSelectionSetBoxBase.selections
  }

  public var resultMap: ResultMap { self._box.resultMap }
}
