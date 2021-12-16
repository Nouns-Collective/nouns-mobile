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
  
  func testLiveAuctionStateDidChange() async throws {
      
      enum MockDataURLResponder: MockURLResponder {
          static func respond(to request: URLRequest) throws -> Data? {
              Fixtures.data(contentOf: "live-auction-response-valid", withExtension: "json")
          }
      }
      
      // given
      let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
      let client = URLSessionNetworkClient(urlSession: urlSession)
      let graphQLClient = GraphQLClient(networkingClient: client)
      let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
      
      // when
      let auction = try await nounsProvider.liveAuctionStateDidChange()
      
      // then
      XCTAssertEqual(auction, Auction.fixture)
  }
  
  func testLiveAuctionStateDidChangeFailure() {
    fatalError("Implementation for \(#function) is missing")
  }
}
