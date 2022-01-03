//
//  LiveAuctionStateDidChangeTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
import Combine
@testable import Services

final class LiveAuctionStateDidChangeTests: XCTestCase {
  
  func assertAuctionEquality(_ lhs: Auction, _ rhs: Auction) {
    // Auction
    XCTAssertEqual(lhs.id, rhs.id)
    XCTAssertEqual(lhs.amount, rhs.amount)
    XCTAssertEqual(lhs.startTime, rhs.startTime)
    XCTAssertEqual(lhs.endTime, rhs.endTime)
    XCTAssertEqual(lhs.settled, rhs.settled)
    
    // Noun
    XCTAssertEqual(lhs.noun.id, rhs.noun.id)
    XCTAssertEqual(lhs.noun.name, rhs.noun.name)
    XCTAssertEqual(lhs.noun.seed, rhs.noun.seed)
    
    // Account
    XCTAssertEqual(lhs.noun.owner.id, rhs.noun.owner.id)
  }
  
  /// Assert that the short-poll mechanism does update the live auction model when changes occur.
  func testLiveAuctionStateDidChange() throws {
    
    enum MockDataURLResponder: MockURLResponder {
      /// States the current fake auction state that should be state to the network API.
      static var auctionStateIndex = 0
      
      static let auctionFilenames = [
        /// Fake initial auction fetch.
        "live-auction-response-initial",
        /// Fake auction's new bid
        "live-auction-response-new-bid",
        /// Fake auction's settled.
        "live-auction-response-settled",
        /// Fake new auction published.
        "new-live-auction-response",
      ]
      
      static func respond(to request: URLRequest) throws -> Data? {
        defer { auctionStateIndex += 1 }
        return Fixtures.data(
          contentOf: auctionFilenames[auctionStateIndex],
          withExtension: "json"
        )
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    let expectation = expectation(description: #function)
    // Matches the number of the auction states.
    expectation.expectedFulfillmentCount = 4
    
    Task {
      var fetchedAuctions = [Auction]()
      for try await auction in nounsProvider.liveAuctionStateDidChange() {
        fetchedAuctions.append(auction)
        
        expectation.fulfill()
      }
      
      XCTAssertEqual(fetchedAuctions, [
        .fixture,
          .fixtureLiveNewBid,
          .fixtureLiveSettled,
          .fixtureLiveNew
      ])
    }
    
    wait(for: [expectation], timeout: 4.0)
  }
  
  /// Asserts whether the short-poll mechanism is not stopped after
  /// the failure of the live auction retrieval.
  func testLiveAuctionStateDidChangeContinueAfterAuctionFetchFail() {
    
  }
  
  /// Asserts the live auction does always fetch the most recent creation
  /// auction instead of just the non-settled ones.
  func testLiveAuctionStateDidChangeFetchMostRecentAuction() {
    
  }
}
