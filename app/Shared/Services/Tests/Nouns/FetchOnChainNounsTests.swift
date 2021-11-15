//
//  FetchOnChainNounsTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
import Combine
@testable import Services

final class FetchOnChainNounsTests: XCTestCase {
    
    func testFetchOnChainNounsSucceed() throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "on-chain-nouns-response-valid", withExtension: "json")
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
        
        var cancellables = Set<AnyCancellable>()
        let fetchExpectation = expectation(description: #function)
        
        // when
        nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
                
            } receiveValue: { nouns in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertFalse(nouns.isEmpty)
                
                let fetchNoun = nouns.first
                let expectedNoun = Noun.fixture
                
                XCTAssertEqual(fetchNoun?.id, expectedNoun.id)
                XCTAssertEqual(fetchNoun?.owner, expectedNoun.owner)
                XCTAssertEqual(fetchNoun?.seed, expectedNoun.seed)
                
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
    
    func testFetchOnChainNounsFailure() {
        
        enum MockErrorURLResponder: MockURLResponder {
          static func respond(to request: URLRequest) throws -> Data? {
            throw QueryError.badQuery
          }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
        
        var cancellables = Set<AnyCancellable>()
        let fetchExpectation = expectation(description: #function)
        
        // when
        nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
            .sink { completion in
                if case .failure = completion {
                    XCTAssertTrue(Thread.isMainThread)
                    
                    fetchExpectation.fulfill()
                }
                
            } receiveValue: { _ in
                XCTFail("💥 result unexpected")
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
}
