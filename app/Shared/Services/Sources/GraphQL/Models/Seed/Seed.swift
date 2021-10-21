//
//  Seed.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public struct Seed {
  var background: Int
  var glasses: Int
  var head: Int
  var body: Int
  var accessory: Int
}

extension Seed: GraphResponse {
  public init?(_ apolloResponse: GraphQLSelectionSet?) {
    guard let response = apolloResponse as? NounsListQuery.Data.Noun.Seed else { return nil }
    
    guard let background = Int(response.background),
          let glasses = Int(response.glasses),
          let head = Int(response.head),
          let body = Int(response.body),
          let accessory = Int(response.accessory) else { return nil }
    
    self.background = background
    self.glasses = glasses
    self.head = head
    self.body = body
    self.accessory = accessory
  }
}
