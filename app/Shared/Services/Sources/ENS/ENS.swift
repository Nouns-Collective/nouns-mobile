//
//  ENS.swift
//  Ethereum Name Service
//
//  Created by Ziad Tamim on 21.10.21.
//

import Foundation
import Combine
import web3

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
  func domainLookup(address: String) async throws -> String
}

/// Ethereum Name Service.
public struct ENSDomain: Decodable, Equatable {
  
  /// The ETH address
  public let id: String
  
  /// The domain name
  public let name: String
}

/// An ENS provider utilizing the ENS name service and Ethereum Client from the `web3swift` package
public class Web3ENSProvider: ENS {

  /// The ethereum client layer provided by `web3swift` package
  private let ethereumClient: EthereumClient
  
  /// The ENS name service layer provided by the `web3swift` package
  private let nameService: EthereumNameService
  
  /// Cache machsim to reduce the cost of hitting the server for domains already fecthed.
  private var cache = [String: String]()
  
  public init(ethereumClient: EthereumClient) {
    self.ethereumClient = ethereumClient
    self.nameService = EthereumNameService(client: ethereumClient)
  }
  
  public func domainLookup(address: String) async throws -> String {
    // Check the cache for already fecthed domain.
    if let name = cache[address] {
      return name
    }
    
    return try await withCheckedThrowingContinuation { continuation in
      nameService.resolve(address: EthereumAddress(address)) { [weak self] error, name in
        if let error = error {
          continuation.resume(throwing: error)
        }
        
        if let name = name {
          // Save name in memory
          self?.cache[address] = name
          
          continuation.resume(returning: name)
        }
      }
    }
  }
}
