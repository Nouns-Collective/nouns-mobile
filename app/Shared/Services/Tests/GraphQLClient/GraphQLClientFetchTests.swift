//
//  GraphQLFetchTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 20.10.21.
//

import XCTest
@testable import Services

final class GraphQLClientFetchTests: XCTestCase {
    
    /// Tests a successful request and response against the GraphQL client
    func testGraphQLClientFetchQuerySucceed() async throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "nouns-response-valid", withExtension: "json")
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let query = NounsSubgraph.NounsQuery(limit: 10, skip: 0)
        
        // when
        let page: Page<[Noun]> = try await graphQLClient.fetch(query, cachePolicy: .fetchIgnoringCacheData)
        
        // then
        XCTAssertFalse(page.data.isEmpty)
    }
    
    /// Tests a bad server response
    func testGraphQLClientFetchQueryFailureWithBadServerResponseError() async {
        
        enum MockErrorURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                throw URLError(.badServerResponse)
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let query = NounsSubgraph.NounsQuery(limit: 10, skip: 0)
        
        do {
            // when
            let _: Page<[Noun]> = try await graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            XCTFail("💥 result unexpected")
        } catch {
            // then
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
}
