//
//  FetchNounActivitiesTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
import Combine
@testable import Services

final class FetchNounActivitiesTests: XCTestCase {
    
    func testFetchNounActivitiesSucceed() throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "nouns-activities-response-valid", withExtension: "json")
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
        nounsProvider.fetchActivity(for: "0")
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
                
            } receiveValue: { activities in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(activities, Fixtures.validActivities)
                
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
    
    func testFetchNounActivitiesFailure() {
        
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
