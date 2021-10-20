//
//  GraphResponse.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public protocol GraphResponse {
  init?(_ apolloResponse: GraphQLSelectionSet?)
}
