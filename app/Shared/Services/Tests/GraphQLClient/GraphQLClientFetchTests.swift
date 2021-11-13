//
//  GraphQLFetchTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 20.10.21.
//

import XCTest
import Combine
@testable import Services

final class GraphQLClientFetchTests: XCTestCase {
    
    /// Tests a successful request and response against the GraphQL client
    func testGraphQLClientFetchQuerySucceed() throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "on-chain-nouns-response-valid", withExtension: "json")
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let query = NounsSubgraph.NounsQuery(first: 10, skip: 0)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        graphQLClient.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { (page:Page<[Noun]>) in
                XCTAssertFalse(page.data.isEmpty)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests a bad server response
    func testGraphQLClientFetchQueryFailureWithBadServerResponseError() throws {
        
        enum MockErrorURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                throw URLError(.badServerResponse)
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let query = NounsSubgraph.NounsQuery(first: 10, skip: 0)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
                    
                    expectation.fulfill()
                }
                
            } receiveValue: { (_: Page<[Noun]>) in
                XCTFail("💥 result unexpected")
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 1.0)
    }
}
