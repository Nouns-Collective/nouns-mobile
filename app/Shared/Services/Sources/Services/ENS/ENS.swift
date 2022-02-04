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
  case downloadFailed
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
public actor Web3ENSProvider: ENS {

  /// The ethereum client layer provided by `web3swift` package
  private let ethereumClient: EthereumClient
  
  /// The ENS name service layer provided by the `web3swift` package
  private let nameService: EthereumNameService
  
  /// Cache machsim to reduce the cost of hitting the server for domains already fecthed.
  private var cache: [String: DownloadState] = [:]
  
  private enum DownloadState {
    case inProgress(Task<String, Error>)
    case completed(String)
    case failed
  }
  
  public convenience init() {
    do {
      /// The web3Client is abstracted out to a private property as it is re-used in both the Ethereum and ENS front-layer clients below.
      /// Views should only use `ethClient` and `ensNameService` to communicate with each respective part,
      /// as those protocols are not subject to change
      let web3Client = try Web3Client()
      self.init(ethereumClient: web3Client.client)
      
    } catch {
      fatalError("💥 Couldn't instantiate the web3Client: \(error)")
    }
  }
  
  init(ethereumClient: EthereumClient) {
    self.ethereumClient = ethereumClient
    self.nameService = EthereumNameService(client: ethereumClient)
  }
  
  public func domainLookup(address: String) async throws -> String {
    // Check the address availability in cache.
    if let cached = cache[address] {
      switch cached {
      case .completed(let image):
        return image
        
      case .inProgress(let task):
        return try await task.value
        
      case .failed:
        throw ENSError.downloadFailed
      }
    }
    
    let download: Task<String, Error> = Task.detached { [weak self] in
      guard let self = self else {
        throw CancellationError()
      }
      return try await self.resolve(address: address)
    }
    
    do {
      let name = try await download.value
      updateCache(address: address, name: name)
      return name
      
    } catch {
      cache[address] = .failed
      throw error
    }
  }
  
  private func resolve(address: String) async throws -> String {
    try await withCheckedThrowingContinuation { continuation in
      nameService.resolve(address: EthereumAddress(address)) { error, name in
        
        if let error = error {
          continuation.resume(throwing: error)
        }
        
        if let name = name {
          continuation.resume(returning: name)
        }
      }
    }
  }
  
  private func updateCache(address: String, name: String) {
    cache[address] = .completed(name)
  }
}
