//
//  Nouns.swift
//  Nouns DAO
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine
import CoreData
import web3
import BigInt

/// `onChainNounsService` request error.
public enum OnChainNounsRequestError: Error {
  
  /// The response is empty
  case noData
}

/// Service allows interacting with the `OnChain Nouns`.
public protocol OnChainNounsService: AnyObject {
  
  func fetchTreasury() async throws -> String
  
  /// Fetches the list of Nouns settled from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Noun` type  instance or an error was encountered.
  func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> [Noun]
  
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
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A publisher emitting a list of `Activity` type  instance or an error was encountered.
  func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> [Vote]
  
  /// Fetches the list of Bids of a given Noun from the chain.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///
  /// - Returns: A publisher emitting a list of `Bid` type  instance or an error was encountered.
  func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> [Bid]
  
//  /// Registers a publisher that publishes the last auction and bid created on
//  /// the network  state changes.
//  ///
//  /// The publisher will emit events on the **main** thread.
//  ///
//  /// - Returns: A publisher emitting a `Auction` instance or an error was encountered.
//  func liveAuctionStateDidChange() async throws -> Auction
  
  func liveAuctionStateDidChange() -> AnyPublisher<Auction, Never>
  
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

/// Concrete implementation of the `onChainNounsService` using `TheGraph` Service.
public class TheGraphNounsProvider: OnChainNounsService {
  private let graphQLClient: GraphQL
  
  /// The ethereum client layer provided by `web3swift` package
  private let ethereumClient = EthereumClient(url: CloudConfiguration.Infura.mainnet.url!)
  
  /// NounsDAOExecutor contract address.
  private enum Address {
    static let ethDAOExecutor = "0x0BC3807Ec262cB779b38D65b38158acC3bfedE10"
    static let stEthDAOExecutor = "0xae7ab96520de3a18e5e111b5eaab095312d7fe84"
  }
  
  public init(
    graphQLClient: GraphQL = GraphQLClient()
  ) {
    self.graphQLClient = graphQLClient
  }
  
  private func ethTreasury() async throws -> BigUInt {
    try await withCheckedThrowingContinuation { continuation in
      ethereumClient.eth_getBalance(
        address: EthereumAddress(Address.ethDAOExecutor),
        block: .Latest
      ) { error, balance in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        if let balance = balance {
          continuation.resume(returning: balance)
        }
      }
    }
  }
  
  private func stEthTreasury() async throws -> BigUInt {
    try await withCheckedThrowingContinuation { continuation in
      ethereumClient.eth_getBalance(
        address: EthereumAddress(Address.stEthDAOExecutor),
        block: .Latest
      ) { error, balance in
        if let error = error {
          return continuation.resume(throwing: error)
        }

        if let balance = balance {
          continuation.resume(returning: balance)
        }
      }
    }
  }
  
  public func fetchTreasury() async throws -> String {
    async let eth = ethTreasury()
    async let stEth = stEthTreasury()
    
    let (ethValue, stEthValue) = try await (eth, stEth)
    return String(ethValue + stEthValue)
  }
  
  public func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> [Noun] {
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
  
  public func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> [Vote] {
    let query = NounsSubgraph.ActivitiesQuery(nounID: nounID, first: limit, skip: cursor)
    let page: Page<[Vote]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
  
  public func liveAuctionStateDidChange() -> AnyPublisher<Auction, Never> {
    let subject = PassthroughSubject<Auction, Never>()
    
    let task = Task {
      do {
        var auction = try await fetchLiveAuction()
        subject.send(auction)
        
        // Timer sequence to emit every 1 second.
        for await _ in Timer.publish(every: 1, on: .main, in: .common).autoconnect().values {
          let newAuction = try await fetchLiveAuction()
          if newAuction.id != auction.id || newAuction.amount != auction.amount {
            auction = newAuction
            subject.send(auction)
          }
        }

      } catch { }
    }
    
    return subject
      .handleEvents(receiveCancel: {
        task.cancel()
      })
      .eraseToAnyPublisher()
  }
  
  private func fetchLiveAuction() async throws -> Auction {
    let query = NounsSubgraph.LiveAuctionSubscription()
    let page: Page<[Auction]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )

    guard let auction = page.data.first else {
      throw OnChainNounsRequestError.noData
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
  
  public func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> [Bid] {
    let query = NounsSubgraph.BidsQuery(nounID: nounID, first: limit, skip: cursor)
    let page: Page<[Bid]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return page.data
  }
}
