// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
    let nounsProvider = TheGraphOnChainNouns(graphQLClient: graphQLClient)
    
    let _: [Auction] = [.fixture(), .fixtureLiveNewBid, .fixtureLiveNew]
    let expectation = expectation(description: #function)
    expectation.expectedFulfillmentCount = MockDataURLResponder.auctionFilenames.count
    
    let task = Task {
      for try await auctions in nounsProvider.liveAuctionStateDidChange() {
        print("===", auctions)
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 3.0)
    
    task.cancel()
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
    let nounsProvider = TheGraphOnChainNouns(graphQLClient: graphQLClient)
    
    let _: [Auction] = [.fixture(), .fixtureLiveNewBid, .fixtureLiveNew]
    let expectation = expectation(description: #function)
    expectation.expectedFulfillmentCount = 3
    
    let task = Task {
      for try await _ in nounsProvider.liveAuctionStateDidChange() {
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 4.0)
    
    task.cancel()
  }
}
