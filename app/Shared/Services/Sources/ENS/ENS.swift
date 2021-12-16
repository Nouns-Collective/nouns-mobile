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
  func domainLookup(token: String) async throws -> String
}

/// Ethereum Name Service.
public struct ENSDomain: Decodable, Equatable {
  
  /// The ETH address
  public let id: String
  
  /// The domain name
  public let name: String
}

public class TheGraphENSProvider: ENS {
  private let graphQLClient: GraphQL
  
  public init(graphQLClient: GraphQL = GraphQLClient()) {
    self.graphQLClient = graphQLClient
  }
  
  public func domainLookup(token: String) async throws -> String {
    let query = ENSSubgraph.DomainLookupQuery(token: token)
    let page: Page<[ENSDomain]> = try await graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
    guard let name = page.data.first?.name else {
      throw ENSError.noDomain
    }
    return name
  }
}
