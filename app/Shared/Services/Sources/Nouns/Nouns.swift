//
//  Nouns.swift
//  Nouns DAO
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine
import CoreData

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
    func fetchAuctions(settled: Bool, limit: Int, cursor: Int) -> AnyPublisher<[Auction], Error>
    
    /// Fetches the list of Activities of a given Noun from the chain.
    ///
    /// The publisher will emit events on the **main** thread.
    ///
    /// - Parameters:
    ///   - nounID: A settled `Noun` identifier.
    ///
    /// - Returns: A publisher emitting a list of `Activity` type  instance or an error was encountered.
    func fetchActivity(for nounID: String) -> AnyPublisher<[Vote], Error>
    
    /// Fetches the list of Bids of a given Noun from the chain.
    ///
    /// The publisher will emit events on the **main** thread.
    ///
    /// - Parameters:
    ///   - nounID: A settled `Noun` identifier.
    ///
    /// - Returns: A publisher emitting a list of `Bid` type  instance or an error was encountered.
    func fetchBids(for nounID: String) -> AnyPublisher<[Bid], Error>
    
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
    private let graphQLClient: GraphQL
//    private let persistentStore: PersistenceStore
    
    public init(
        graphQLClient: GraphQL = GraphQLClient()//,
//        persistentStore: PersistenceStore = CoreDataStore(dataModel: "Nouns")
    ) {
        self.graphQLClient = graphQLClient
//        self.persistentStore = persistentStore
    }
    
    public func fetchOnChainNouns(limit: Int, after cursor: Int) -> AnyPublisher<[Noun], Error> {
        let query = NounsSubgraph.NounsQuery(first: limit, skip: cursor)
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Noun]>) in
                return page.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchAuctions(settled: Bool, limit: Int = 10, cursor: Int = 0) -> AnyPublisher<[Auction], Error> {
        let query = NounsSubgraph.AutionsQuery(settled: settled, first: limit, skip: cursor)
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Auction]>) in
                return page.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchActivity(for nounID: String) -> AnyPublisher<[Vote], Error> {
        let query = NounsSubgraph.ActivitiesQuery(nounID: nounID)
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Vote]>) in
                return page.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func liveAuctionStateDidChange() -> AnyPublisher<Auction, Error> {
        let query = NounsSubgraph.LiveAuctionSubscription()
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Auction]>) in
                return page.data.first
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchProposals(limit: Int = 10, after cursor: Int = 0) -> AnyPublisher<[Proposal], Error> {
        let query = NounsSubgraph.ProposalsQuery(first: limit, skip: cursor)
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Proposal]>) in
                return page.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func fetchBids(for nounID: String) -> AnyPublisher<[Bid], Error> {
        let query = NounsSubgraph.BidsQuery(nounID: nounID)
        return graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .compactMap { (page: Page<[Bid]>) in
                return page.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
