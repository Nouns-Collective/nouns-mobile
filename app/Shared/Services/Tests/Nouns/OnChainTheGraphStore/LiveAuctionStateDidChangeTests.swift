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
  
  fileprivate enum AuctionState {
    case none
    case initial
    case newBid
    case settled
    case new
  }
  
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
  
  func testLiveAuctionStateDidChange() throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static var auctionState: AuctionState = .none
      
      static func respond(to request: URLRequest) throws -> Data? {
        auctionState.next()
        return Fixtures.data(contentOf: auctionState.filename, withExtension: "json")
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
      for try await auction in nounsProvider.liveAuctionStateDidChange() {
        
        switch MockDataURLResponder.auctionState {
        case .none:
          XCTFail("No filename associated with the Auction State `None`")
          
        case .initial:
          assertAuctionEquality(auction, .fixture)
          expectation.fulfill()
          
        case .newBid:
          assertAuctionEquality(auction, .fixtureLiveNewBid)
          expectation.fulfill()
          
        case .settled:
          assertAuctionEquality(auction, .fixtureLiveSettled)
          expectation.fulfill()
          
        case .new:
          assertAuctionEquality(auction, .fixtureLiveNew)
          expectation.fulfill()
        }
      }
    }
    
    wait(for: [expectation], timeout: 5.0)
  }
}

extension LiveAuctionStateDidChangeTests.AuctionState {
  
  var filename: String {
    switch self {
    case .none:
      fatalError("No filename associated with the Auction State `None`")
      
    case .initial:
      return "live-auction-response-initial"
      
    case .newBid:
      return "live-auction-response-new-bid"
      
    case .settled:
      return "live-auction-response-settled"
      
    case .new:
      return "new-live-auction-response"
    }
  }
  
  mutating func next() {
    switch self {
    case .none:
      self = .initial
      
    case .initial:
      self = .newBid
      
    case .newBid:
      self = .settled
      
    case .settled:
      self = .new
      
    case .new:
      XCTFail("There is next state for the case `New Auction`.")
    }
  }
}
