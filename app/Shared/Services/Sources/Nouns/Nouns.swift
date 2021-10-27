//
//  Nouns.swift
//  Nouns DAO
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine

enum ResponseDecodingError: Error {
  case typeNotFound(type: Any.Type)
}

struct CodingKeys: CodingKey {
  init?(intValue: Int) {
    return nil
  }
  
  init(stringValue: String) {
    self.stringValue = stringValue
  }
  
  let stringValue: String
  let intValue: Int? = nil
}

/// The Auction
public struct Auction {
  
  /// The Noun
  public let noun: Noun
  
  /// The current highest bid amount
  public let amount: String
  
  /// The time that the auction started
  public let startTime: String
  
  /// The time that the auction is scheduled to end
  public let endTime: String
  
  /// Whether or not the auction has been settled
  public let settled: Bool
}

/// The owner of the Noun
public struct Account {
  
  /// An Account is any address that holds any
  /// amount of Nouns, the id used is the blockchain address.
  public let id: String
}

/// The Noun
public struct Noun {
  
  public let id: String
  
  public let owner: Account
  
  //  /// The seed used to determine the Noun's traits.
  //  public let seed: Seed
}

/// The seed used to determine the Noun's traits.
public struct Seed: Decodable {
  
  /// The background trait.
  public let background: Trait
  
  /// The glasses trait.
  public let glasses: Trait
  
  /// The head trait.
  public let head: Trait
  
  /// The body trait.
  public let body: Trait
  
  /// The accessory trait.
  public let accessory: Trait
}

/// Status of the proposal
public enum ProposalStatus: String {
  case pending = "PENDING"
  case active = "ACTIVE"
  case cancelled = "CANCELLED"
  case vetoed = "VETOED"
  case queued = "QUEUED"
  case executed = "EXECUTED"
}

/// The Proposal
public struct Proposal {
  
  /// Block number from where the voting starts
  public let startBlock: String
  
  /// Block number from where the voting ends
  public let endBlock: String
  
  /// Status of the proposal.
  public let status: ProposalStatus
  
  /// Description of the change.
  public let description: String
}

/// This provider class allows interacting with cloud Nouns.
public protocol Nouns {
  
  /// Fetches the list of Nouns settled from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Noun` type  instance or an error was encountered.
  func fetchOnChainNouns(limit: Int, after cursor: Int) -> AnyPublisher<[Noun], Error>
  
  /// Registers a publisher that publishes the last auction and bid created on
  /// the network  state changes.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Returns: A publisher emitting a `Auction` instance or an error was encountered.
  func liveAuctionStateDidChange() -> AnyPublisher<Auction, Error>
  
  /// Fetches the list of proposals for all type status.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Proposal` type  instance or an error was encountered.
  func fetchProposals(limit: Int, after cursor: Int) -> AnyPublisher<[Proposal], Error>
}

public class TheGraphNounsProvider: Nouns {
  private let graphQLClient: GraphQLClient
  
  init(graphQLClient: GraphQLClient) {
    self.graphQLClient = graphQLClient
  }
  
  public func fetchOnChainNouns(limit: Int, after cursor: Int) -> AnyPublisher<[Noun], Error> {
    let query = NounsSubgraph.NounsListQuery(first: limit, skip: cursor)
    return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .compactMap { (responseData: HTTPResponse<Page<[Noun]>>) in
        return responseData.data.data
      }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  public func liveAuctionStateDidChange() -> AnyPublisher<Auction, Error> {
    fatalError("Implementation for \(#function) missing")
  }
  
  public func fetchProposals(limit: Int, after cursor: Int) -> AnyPublisher<[Proposal], Error> {
    let query = NounsSubgraph.ProposalListQuery(first: limit, skip: cursor)
    return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .compactMap { (responseData: HTTPResponse<Page<[Proposal]>>) in
        return responseData.data.data
      }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}

extension Noun: Decodable { }
extension Account: Decodable { }
extension Auction: Decodable { }
extension Proposal: Decodable { }
extension ProposalStatus: Decodable { }
