//
//  File.swift
//  
//
//  Created by Ziad Tamim on 21.12.21.
//

import Foundation
import XCTest
@testable import Services

final class FetchTreasuryRealBackendTests: XCTestCase {
  
  func testFetchTreasuryRealBackendTests() async throws {
    // given
    let service = TheGraphOnChainNouns()
    
    // when
    let treasury = try await service.fetchTreasury()
    
    // then
    XCTAssertNotNil(treasury)
  }
  
}
