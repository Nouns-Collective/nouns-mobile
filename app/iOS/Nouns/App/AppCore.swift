//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine
import Services

/// <#Description#>
class AppCore {
  
  lazy var graphQLClient: GraphQL = {
    GraphQLClient()
  }()
  
  lazy var nounsService: Nouns = {
    TheGraphNounsProvider(graphQLClient: graphQLClient)
  }()
  
//  lazy var initialState: AppStore = {
//    let onChainNounsState = OnChainNounsState(nouns: [])
//    let onChainExplorerState = OnChainExplorerState(onChainNounState: onChainNounsState)
//    let appState = AppState(onChainExplorerState: onChainExplorerState)
//    return AppStore(
//      initial: appState,
//      reducer: appReduce,
//      middlewares: [
//        onChainNounsMiddleware(service: nounsService),
//      ]
//    )
//  }()
}
