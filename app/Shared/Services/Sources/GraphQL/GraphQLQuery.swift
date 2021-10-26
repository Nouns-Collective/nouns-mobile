//
//  GraphQLQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

protocol GraphQLQuery {
  var url: URL { get }
  var query: String { get }
}
