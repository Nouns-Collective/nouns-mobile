//
//  FetchProposalsHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
@testable import Services

final class FetchProposalsHitRealBackendTests: XCTestCase {
    
    func testFetchProposalsHitRealBackend() async throws {
        // given
        let query = NounsSubgraph.ProposalsQuery(limit: 1, skip: 0)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        // when
        let page: Page<[Proposal]> = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            
        // then
        XCTAssertFalse(page.data.isEmpty)
    }
    
}
