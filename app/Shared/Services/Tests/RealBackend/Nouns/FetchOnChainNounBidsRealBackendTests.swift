//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import XCTest
@testable import Services

final class FetchBidsHitRealBackendTests: XCTestCase {
    
    func testFetchBidsHitRealBackend() async throws {
        // given
        let query = NounsSubgraph.BidsQuery(nounID: "99", first: 20, skip: 0)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        // when
        let page: Page<[Bid]> = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
        
        // then
        XCTAssertFalse(page.data.isEmpty)
    }
    
}

