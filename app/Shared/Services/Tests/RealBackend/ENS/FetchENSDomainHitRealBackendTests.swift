//
//  FetchENSDomainHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
@testable import Services

final class FetchENSDomainHitRealBackendTests: XCTestCase {
    
    fileprivate static let token = "0x0000044a32f0964f4bf8fb4d017e230ad33595c0e149b6b2d0c34b733dcf906a"
    
    func testFetchENSDomainHitRealBackend() async throws {
        // given
        let query = ENSSubgraph.DomainLookupQuery(token: Self.token)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        // when
        let domain: String = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
        
        // then
        XCTAssertNotNil(domain)
    }
}
