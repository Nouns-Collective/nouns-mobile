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
  
  /// Assert that the short-poll mechanism does update the live auction model when changes occur.
  func testLiveAuctionStateDidChange() throws {
    
    enum MockDataURLResponder: MockURLResponder {
      /// States the current fake auction state that should be state to the network API.
      static var auctionStateIndex = 0
      
      /// Lists of the various live auction states.
      static let auctionFilenames = [
        // Fake initial auction fetch.
        "live-auction-response-initial",
        // Fake auction's new bid
        "live-auction-response-new-bid",
        // Fake new auction published.
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
    
    Task {
      var auctions = [Auction]()
      for try await auction in nounsProvider.liveAuctionStateDidChange() {
        auctions.append(auction)
      }
      
      XCTAssertEqual(auctions, [
        .fixture(),
          .fixtureLiveNewBid,
          .fixtureLiveSettled,
          .fixtureLiveNew
      ])
      
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0)
  }
  
  /// Asserts whether the short-poll mechanism is not stopped after
  /// the failure of the live auction retrieval.
  func testLiveAuctionStateDidChangeContinueAfterAuctionFetchFail() throws  {
    
    enum MockDataURLResponder: MockURLResponder {
      /// States the current fake auction state that should be state to the network API.
      static var auctionStateIndex = 0
      
      static let auctionFilenames = [
        // Fake initial auction fetch.
        "live-auction-response-initial",
        // Fake auction's new bid.
        "live-auction-response-new-bid",
        // Invalid auction json format.
        "live-auction-response-invalid",
        // Fake new auction published.
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
    let networkClient = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: networkClient)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    let expectation = expectation(description: #function)
    
    Task {
      var auctions = [Auction]()
      for try await auction in nounsProvider.liveAuctionStateDidChange() {
        auctions.append(auction)
      }
      
      XCTAssertEqual(auctions, [
        .fixture(),
          .fixtureLiveNewBid,
          .fixtureLiveSettled,
          .fixtureLiveNew
      ])
      
      expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 4.0)
  }
}
