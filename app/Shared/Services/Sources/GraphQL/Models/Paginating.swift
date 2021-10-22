//
//  Paginating.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation

protocol Paginating {
  associatedtype Query: GraphQLQuerier

  var skip: Int { get }
  func nextPage() -> Query
}
