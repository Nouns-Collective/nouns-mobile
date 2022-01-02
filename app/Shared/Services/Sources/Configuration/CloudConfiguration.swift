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
    }
    
    internal enum ENS {
        case query
    }
  
  internal enum Infura {
      case mainnet
  }
}

extension CloudConfiguration.Nouns {
  
    var url: URL? {
        switch self {
        case .query:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.thegraph.com"
            components.path = "/subgraphs/name/nounsdao/nouns-subgraph"
            return components.url
            
        case .subscription:
            var components = URLComponents()
            components.scheme = "wss"
            components.host = "api.thegraph.com"
            components.path = "/subgraphs/name/nounsdao/nouns-subgraph"
            return components.url
        }
    }
}

extension CloudConfiguration.ENS {
    
    var url: URL? {
        switch self {
        case .query:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.thegraph.com"
            components.path = "/subgraphs/name/ensdomains/ens"
            return components.url
        }
    }
}

extension CloudConfiguration.Infura {
    
    var url: URL? {
        switch self {
        case .mainnet:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "mainnet.infura.io"
            components.path = "/v3/2abc0ffe9968475ab1858dfdf9d0365a"
            return components.url
        }
    }
}

