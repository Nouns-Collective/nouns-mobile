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
  
  /// Asynchronously fetch the Nouns treasury from the eth network.
  ///
  /// - Returns: The total amount stored of `Ether + staked Ether in Lido`.
  func fetchTreasury() async throws -> String
  
  /// Fetches a single noun given an `id`
  ///
  /// - Parameters:
  ///   - id: The id of the noun to fetch
  ///
  /// - Returns: A single, optional, instance of a `Noun` type or throw an error.
  func fetchNoun(withId id: String) async throws -> Noun?
  
  /// Asynchronously fetches the list of the settled Nouns from the chain.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Noun` type  instance or throw an error.
  func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> Page<[Noun]>
  
  /// Asynchronously fetches the list of auction settled from the chain.
  ///
  /// - Parameters:
  ///   - settled: Whether or not the auction has been settled.
  ///   - includeNounderOwned: Whether or not to include nouns owned by nounders (every 10th noun)
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Auction` type  instance or throw an error.
  func fetchAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int) async throws -> Page<[Auction]>
  
  /// An asynchronous sequence that  produce the live auction and
  /// react to its properties changes
  ///
  /// - Returns: A `Auction` instance or throw an error.
  func liveAuctionStateDidChange() -> AsyncThrowingStream<Auction, Error>
  
  /// An asynchronous sequence that  produce the last settled auction added.
  ///
  /// - Returns: A `Auction` instance or throw an error.
  func settledAuctionsDidChange() -> AsyncStream<Auction>
  
  /// Asynchronously fetches the list of Activities of a given Noun from the chain.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Activity` type  instance or throw an error.
  func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Vote]>
  
  /// Asynchronously fetches the list of Bids of a given Noun from the chain.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///
  /// - Returns: A list of `Bid` type  instance or throw an error.
  func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Bid]>
  
  /// Asynchronously fetches the list of proposals for all type status.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Proposal` type  instance or throw an error.
  func fetchProposals(limit: Int, after cursor: Int) async throws -> Page<[Proposal]>
}

/// Concrete implementation of the `onChainNounsService` using `TheGraph` Service.
public class TheGraphOnChainNouns: OnChainNounsService {
  
  private let pageProvider: PageProvider
  
  private let graphQLClient: GraphQL
  
  /// The ethereum client layer provided by `web3swift` package
  private let ethereumClient = EthereumClient(url: CloudConfiguration.Infura.mainnet.url!)
  
  /// NounsDAOExecutor contract address.
  private enum Address {
    static let ethDAOExecutor = "0x0BC3807Ec262cB779b38D65b38158acC3bfedE10"
    static let stEthDAOExecutor = "0xae7ab96520de3a18e5e111b5eaab095312d7fe84"
  }
  
  public convenience init() {
    self.init(graphQLClient: GraphQLClient())
  }
  
  init(graphQLClient: GraphQL) {
    self.graphQLClient = graphQLClient
    self.pageProvider = PageProvider(graphQLClient: graphQLClient)
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
      let function = ERC20Functions.balanceOf(contract: EthereumAddress(Address.stEthDAOExecutor), account: EthereumAddress(Address.ethDAOExecutor))
      
      function.call(
        withClient: ethereumClient,
        responseType: ERC20Responses.balanceResponse.self
      ) { error, balanceResponse in
        if let error = error {
          return continuation.resume(throwing: error)
        }
        
        if let balanceResponse = balanceResponse {
          continuation.resume(returning: balanceResponse.value)
        }
      }
    }
  }
  
  public func fetchTreasury() async throws -> String {
    async let eth = ethTreasury()
    async let stEth = stEthTreasury()
    
    // To match the nouns.wtf website, eth and stEth are compared as a
    // 1:1 ratio and as such are added together without conversion.
    // The precise value is slightly different
    let (ethValue, stEthValue) = try await (eth, stEth)
    return String(ethValue + stEthValue)
  }
  
  public func fetchNoun(withId id: String) async throws -> Noun? {
    let query = NounsSubgraph.NounQuery(id: id)
    let noun: Page<[Noun]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return noun.data.first
  }
  
  public func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> Page<[Noun]> {
    let query = NounsSubgraph.NounsQuery(limit: limit, skip: cursor)
    let page: Page<[Noun]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int) async throws -> Page<[Auction]> {

    // Deduct the expected number of nounder owned nouns if `includeNounderOwned` is set to true
    let auctionLimit = limit - (includeNounderOwned ? limit / 10 : 0)
    let query = NounsSubgraph.AuctionsQuery(settled: settled, limit: auctionLimit, skip: cursor)
    
    var page: Page<[Auction]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
      
    // Fetch nounder owned nouns, if requested
    if includeNounderOwned {
      page = try await fetchNounderOwnedNouns(within: page)
    }
    
    return page
  }
  
  /// An implementation to seperately fetch nounder owned nouns, as the GraphQL
  /// endpoint for returning auctions does not return nounder-owned nouns by default
  private func fetchNounderOwnedNouns(within page: Page<[Auction]>) async throws -> Page<[Auction]> {
    
    // Temporary modifiable instance of Page
    var newPage = page
    
    /// `lastNoun` is understood as the latest noun created in this page,
    /// with the highest numerical `nounId`, which would be presented
    /// first in the array as it is fetched sorted, with latest being first
    ///
    /// `firstNoun` is understood as the first noun created in this page,
    /// with the lowest numerical `nounId`, which would be presented
    /// last in the array as it is fetched sorted, with oldest being last
    guard let lastNoun = page.data.first?.noun,
          let firstNoun = page.data.last?.noun,
          let lastNounId = Int(lastNoun.id),
          let firstNounId = Int(firstNoun.id) else {
            return page
          }
    
    /// We add one to the end of the list (lastNounId) in the case of edge cases, where the
    /// lastNounId ends with a "9", such as 29. The following settled auction page would
    /// skip the 10th value and go straight to 31. Adding one makes sure to capture "30".
    ///
    /// Additionally, we subtract one from the start of the list (firstNounId): if the firstNounId is a "1",
    /// "0" is skipped - subtracting one makes sure to include "0".
    let end = (lastNounId + 1) - ((lastNounId + 1) % 10)
    let start = firstNounId - 1
    
    let auctions = try await withThrowingTaskGroup(of: Auction.self, returning: [Auction].self) { [weak self] taskGroup in
      
      for nounId in stride(from: end, through: start, by: -10) {
        taskGroup.addTask { [weak self] in
          guard var noun = try await self?.fetchNoun(withId: String(nounId)) else {
            throw "💥 Couldn't fetch noun id \(nounId)"
          }
          
          /// While every 10th noun does automatically go to nounders, the nounders can choose
          /// to sell/transfer the noun to other people. To match nouns.wtf, we list the owner of every 10th noun
          /// as belonging to "nounders.eth" but that may not always be accurate based on any exchanges of ownership
          /// that happened thereafter.
          noun.isNounderOwned = true
          return Auction(id: noun.id, noun: noun, amount: "N/A", startTime: .zero, endTime: .zero, settled: true, bidder: noun.owner)
        }
      }
      
      return try await taskGroup.reduce(into: [Auction](), { $0 += [$1] })
    }
    
    // Add auctions to existing page
    newPage.data.append(contentsOf: auctions)
    
    // Sort page data
    newPage.data = newPage.data.sorted(by: { auctionOne, auctionTwo in
      guard let auctionOneId = Int(auctionOne.noun.id), let auctionTwoId = Int(auctionTwo.noun.id) else {
        return false
      }
      return auctionOneId > auctionTwoId
    })
    
    return newPage
  }
  
  public func settledAuctionsDidChange() -> AsyncStream<Auction> {
    AsyncStream { continuation in
      let listener = ShortPolling { () -> Auction in
        // Fetches the unsettled auction from the network.
        let auctionPage = try await self.fetchAuctions(settled: true, includeNounderOwned: true, limit: 1, cursor: 0)
        
        guard let auction = auctionPage.data.first else {
          throw OnChainNounsRequestError.noData
        }
        
        return auction
      }
      
      listener.setEventHandler = { auction in
        continuation.yield(auction)
      }
      
      continuation.onTermination = { @Sendable _  in
        listener.stopPolling()
      }
      
      listener.startPolling()
    }
  }
  
  public func liveAuctionStateDidChange() -> AsyncThrowingStream<Auction, Error> {
    AsyncThrowingStream { [weak self] continuation in
      guard let self = self else { return }
      
      let listener = ShortPolling {
        try await self.fetchLiveAuction()
      }
      
      listener.setEventHandler = { auction in
        continuation.yield(auction)
      }
      
      listener.setErrorHandler = { error in
        continuation.finish(throwing: error)
      }
      
      continuation.onTermination = { @Sendable _  in
        listener.stopPolling()
      }
      
      listener.startPolling()
    }
  }
  
  /// # A helper for the short-poll mechanism to listen to the live auction changes. #
  ///
  /// **Note:** Should be deleted once the changes are watched using a websocket.
  private func fetchLiveAuction() async throws -> Auction {
    let query = NounsSubgraph.LiveAuctionSubscription()
    let page: Page<[Auction]>? = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )

    guard let auction = page?.data.first else {
      throw OnChainNounsRequestError.noData
    }
    
    return auction
  }
  
  public func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Vote]> {
    let query = NounsSubgraph.ActivitiesQuery(nounID: nounID, limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Vote.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchProposals(limit: Int, after cursor: Int) async throws -> Page<[Proposal]> {
    let query = NounsSubgraph.ProposalsQuery(limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Proposal.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Bid]> {
    let query = NounsSubgraph.BidsQuery(nounID: nounID, limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Bid.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
}
