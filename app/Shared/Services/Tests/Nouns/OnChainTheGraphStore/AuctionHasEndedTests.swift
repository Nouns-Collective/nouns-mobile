//
//  AuctionHasEndedTests.swift
//  
//
//  Created by Ziad Tamim on 05.01.22.
//

import XCTest
@testable import Services

final class AuctionHasEndedTests: XCTestCase {
  
  func testAuctionHasEnded() {
    let auction = Auction.fixture()
    XCTAssertTrue(auction.hasEnded)
  }
  
  func testAuctionHasNotEnded() {
    let startTime = Date.now.timeIntervalSince1970 - 200
    let endTime = Date.now.timeIntervalSince1970 + 1000
    let auction = Auction.fixture(startTime: String(startTime), endTime: String(endTime))
    
    XCTAssertFalse(auction.hasEnded)
  }
}
