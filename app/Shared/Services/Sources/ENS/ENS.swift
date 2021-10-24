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
  func fetchDomain(token: String) -> AnyPublisher<String, ENSError>
}

public class TheGraphENSProvider: ENS {
  private let graphQLClient: GraphQLClient
  
  init(graphQLClient: GraphQLClient) {
    self.graphQLClient = graphQLClient
  }
  
  public func fetchDomain(token: String) -> AnyPublisher<String, ENSError> {
    fatalError("You need to implement \(#function) to support Apollo.")
  }
}
