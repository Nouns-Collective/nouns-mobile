//
//  Nouns.swift
//  Nouns DAO
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine
import CoreData

/// `CloudNounsService` request error.
public enum CloudNounsRequestError: Error {
  
  /// The response is empty
  case noData
}

/// Service allows interacting with the `OnChain Nouns`.
public protocol CloudNounsService: AnyObject {
  
  /// Fetches the list of Nouns settled from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Noun` type  instance or an error was encountered.
  func fetchOnChainNouns(limit: Int, after cursor: Int) async throws -> [Noun]
  
  /// Fetches the list of auction settled from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - settled: Whether or not the auction has been settled.
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Auction` type  instance or an error was encountered.
  func fetchAuctions(settled: Bool, limit: Int, cursor: Int) async throws -> [Auction]
  
  /// Fetches the list of Activities of a given Noun from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///
  /// - Returns: A publisher emitting a list of `Activity` type  instance or an error was encountered.
  func fetchActivity(for nounID: String) async throws -> [Vote]
  
  /// Fetches the list of Bids of a given Noun from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///
  /// - Returns: A publisher emitting a list of `Bid` type  instance or an error was encountered.
  func fetchBids(for nounID: String) async throws -> [Bid]
  
  /// Registers a publisher that publishes the last auction and bid created on
  /// the network  state changes.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Returns: A publisher emitting a `Auction` instance or an error was encountered.
  func liveAuctionStateDidChange() async throws -> Auction
  
  /// Fetches the list of proposals for all type status.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Proposal` type  instance or an error was encountered.
  func fetchProposals(limit: Int, after cursor: Int) async throws -> [Proposal]
}

/// Concrete implementation of the `CloudNounsService` using `TheGraph` Service.
public class TheGraphNounsProvider: CloudNounsService {
  private let graphQLClient: GraphQL
  
  public init(
    graphQLClient: GraphQL = GraphQLClient()
  ) {
    self.graphQLClient = graphQLClient
  }
  
  public func fetchOnChainNouns(limit: Int, after cursor: Int) async throws -> [Noun] {
    let query = NounsSubgraph.NounsQuery(first: limit, skip: cursor)
    let page: Page<[Noun]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
  
  public func fetchAuctions(settled: Bool, limit: Int, cursor: Int) async throws -> [Auction] {
    let query = NounsSubgraph.AutionsQuery(settled: settled, first: limit, skip: cursor)
    let page: Page<[Auction]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
  
  public func fetchActivity(for nounID: String) async throws -> [Vote] {
    let query = NounsSubgraph.ActivitiesQuery(nounID: nounID)
    let page: Page<[Vote]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
  
  public func liveAuctionStateDidChange() async throws -> Auction {
    let query = NounsSubgraph.LiveAuctionSubscription()
    let page: Page<[Auction]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    guard let auction = page.data.first else {
      throw CloudNounsRequestError.noData
    }
    return auction
  }
  
  public func fetchProposals(limit: Int, after cursor: Int) async throws -> [Proposal] {
    let query = NounsSubgraph.ProposalsQuery(first: limit, skip: cursor)
    let page: Page<[Proposal]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
  
  public func fetchBids(for nounID: String) async throws -> [Bid] {
    let query = NounsSubgraph.BidsQuery(nounID: nounID)
    let page: Page<[Bid]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
}
