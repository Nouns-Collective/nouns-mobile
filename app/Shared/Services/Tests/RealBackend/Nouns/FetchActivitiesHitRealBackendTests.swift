//
//  FetchActivitiesHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation
import XCTest
@testable import Services

final class FetchActivitiesHitRealBackendTests: XCTestCase {
  
  func testFetchActivitiesHitRealBackend() async throws {
    // given
    let query = NounsSubgraph.ActivitiesQuery(nounID: "0", first: 20, skip: 0)
    let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
    let client = GraphQLClient(networkingClient: networkingClient)
    
    // when
    let page: Page<[Vote]> = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
    
    // then
    XCTAssertTrue(Thread.isMainThread)
    XCTAssertFalse(page.data.isEmpty)
  }
  
}
