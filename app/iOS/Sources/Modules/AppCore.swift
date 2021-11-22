//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine
import Services
import UIKit

class AppCore {
  static let shared = AppCore()
  
  lazy var graphQLClient: GraphQL = {
    GraphQLClient()
  }()
  
  lazy var nounsService: Nouns = {
    TheGraphNounsProvider(graphQLClient: graphQLClient)
  }()
  
  lazy var nounComposer: NounComposer = {
    do {
      return try OfflineNounComposer.default()
    } catch {
      fatalError("Couldn't instantiate the NounComposer: \(error)")
    }
  }()
}
