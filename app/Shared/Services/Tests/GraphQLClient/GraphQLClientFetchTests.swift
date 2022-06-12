// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
