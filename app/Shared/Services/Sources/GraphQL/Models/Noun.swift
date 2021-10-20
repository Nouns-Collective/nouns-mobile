//
//  Noun.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public struct Noun {
  var background: Int
  var glasses: Int
  var head: Int
  var body: Int
  var accessory: Int
}

extension Noun: GraphResponse {
  public init?(_ apolloResponse: GraphQLSelectionSet) {
    guard let response = apolloResponse as? NounsListQuery.Data.Noun else { return nil }
    
    guard let seed = response.seed,
          let background = Int(seed.background),
          let glasses = Int(seed.glasses),
          let head = Int(seed.head),
          let body = Int(seed.body),
          let accessory = Int(seed.accessory) else { return nil }
    
    self.background = background
    self.glasses = glasses
    self.head = head
    self.body = body
    self.accessory = accessory
  }
}
