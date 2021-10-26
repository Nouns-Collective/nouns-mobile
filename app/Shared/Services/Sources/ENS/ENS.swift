//
//  ENS.swift
//  Ethereum Name Service
//
//  Created by Ziad Tamim on 21.10.21.
//

import Foundation
import Combine

/// Various `ENS` error cases.
public enum ENSError: Error {
  case noDomain
}

/// A secure & decentralized way to address resources on and off
/// the blockchain using simple, human-readable names. Access domains and transfer history.
public protocol ENS {
  
  /// Fetches the domain for the address resource on the blockchain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - token: The address resource.
  ///
  /// - Returns: A publisher emitting the domain in a `String` type  instance or an error was encountered.
  func fetchDomain(token: String) -> AnyPublisher<String, Error>
}

public struct ENSDomain {
  /// The address
  public let id: String
  
  /// The domain name
  public let name: String
}

public class ENSSubgraphProvider: ENS {
  private let graphQLClient: GraphQLClient
  
  init(graphQLClient: GraphQLClient) {
    self.graphQLClient = graphQLClient
  }
  
  public func fetchDomain(token: String) -> AnyPublisher<String, Error> {
    let query = ENSSubgraph.DomainLookupQuery(token: token)
    return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .tryCompactMap { (responseData: HTTPResponse<Page<[ENSDomain]>>) in
        if let name = responseData.data.data.first?.name {
          return name
        } else {
          throw ENSError.noDomain
        }
      }
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
}

extension ENSDomain: Decodable {}
