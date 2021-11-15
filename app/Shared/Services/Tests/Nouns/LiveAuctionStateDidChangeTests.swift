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
  
  func testLiveAuctionStateDidChange() throws {
      
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
      
      var cancellables = Set<AnyCancellable>()
      let fetchExpectation = expectation(description: #function)
      
      // when
      nounsProvider.liveAuctionStateDidChange()
          .sink { completion in
              switch completion {
              case .finished:
                  print("Finished")
              case let .failure(error):
                  XCTFail("💥 Something went wrong: \(error)")
              }
              
          } receiveValue: { auction in
              XCTAssertTrue(Thread.isMainThread)
              XCTAssertEqual(auction, Auction.fixture)
              
              fetchExpectation.fulfill()
          }
          .store(in: &cancellables)
      
      // then
      wait(for: [fetchExpectation], timeout: 1.0)
  }
  
  func testLiveAuctionStateDidChangeFailure() {
    fatalError("Implementation for \(#function) is missing")
  }
}
