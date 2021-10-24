//
//  CloudConfiguration .swift
//  Services
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation

internal enum CloudConfiguration {
  
  internal enum Nouns {
    case query
    case subscription
    
    var url: URL {
      switch self {
      case .query:
        return URL(string: "https://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph")!
      case .subscription:
        return URL(string: "wss://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph")!
      }
    }
  }
  
  internal enum ENS {
    case query
    
    var url: URL {
      switch self {
      case .query:
        return URL(string: "https://api.thegraph.com/subgraphs/name/")!
      }
    }
  }
}
