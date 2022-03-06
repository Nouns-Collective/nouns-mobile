//
//  NetworkGraphQLTests.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import XCTest
@testable import Services

final class FetchOnChainNounsHitRealBackendTests: XCTestCase {
    
    func testFetchOnChainNounsHitRealBackend() async throws {
        // given
        let query = NounsSubgraph.NounsQuery(limit: 10, skip: 0)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        // when
        let page: Page<[Noun]> = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
        
        // then
        XCTAssertFalse(page.data.isEmpty)
    }
    
}
