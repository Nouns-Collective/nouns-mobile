//
//  NetworkGraphQLTests.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import XCTest
import Apollo
import ApolloWebSocket
import Combine
@testable import Services

final class GraphQLClientHitRealBackendTests: XCTestCase {
  
  func testFetchOnChainNouns() throws {
    // given
    let query = AnyApolloQuery(Apollolib.NounsListQuery(skip: 0, first: 10))
    let apollo = ApolloClient(url: CloudConfiguration.Nouns.query.url)
    let client = ApolloGraphQLClient(apolloClient: apollo)
    
    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()
    
    // when
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished ", #function)
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { (nouns: Page<[Noun]>) in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertFalse(nouns.data.isEmpty)
        
        expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    // then
    wait(for: [expectation], timeout: 5.0)
  }
  
  func testLiveAuctionSubscription() throws {
    // given
    let store = ApolloStore()
    let request = URLRequest(url: CloudConfiguration.Nouns.subscription.url)
    let webSocketClient = WebSocket(request: request)
    let networkTransport = WebSocketTransport(websocket: webSocketClient)
    let apollo = ApolloClient(networkTransport: networkTransport, store: store)
    let client = ApolloGraphQLClient(apolloClient: apollo)
    
    let subscription = AnyApolloSubscription(Apollolib.AuctionSubscription())

    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()

    // when
    client.subscription(subscription)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished ", #function)
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { (auction: Auction) in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertNotNil(auction)

        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // then
    wait(for: [expectation], timeout: 5.0)
  }
}
