// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
            components.host = "api.goldsky.com"
            components.path = "/api/public/project_cldf2o9pqagp43svvbk5u3kmo/subgraphs/nouns/prod/gn"
            return components.url
            
        case .subscription:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.goldsky.com"
            components.path = "/api/project_cldf2o9pqagp43svvbk5u3kmo/subgraphs/nouns/prod/gn"
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
