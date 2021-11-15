//
//  FetchAuctionsTests.swift
//  
//
//  Created by Ziad Tamim on 14.11.21.
//

import XCTest
import Combine
@testable import Services

final class FetchAuctionsTests: XCTestCase {
    
    func testFetchAuctionsSucceed() throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "auctions-response-valid", withExtension: "json")
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
        nounsProvider.fetchAuctions(settled: true)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
                
            } receiveValue: { auctions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertFalse(auctions.isEmpty)
                
                let expectedAuction = Auction.fixture
                let fetchedAuction = auctions.first
                
                XCTAssertEqual(fetchedAuction?.id, expectedAuction.id)
                XCTAssertEqual(fetchedAuction?.noun, expectedAuction.noun)
                XCTAssertEqual(fetchedAuction?.startTime, expectedAuction.startTime)
                XCTAssertEqual(fetchedAuction?.endTime, expectedAuction.endTime)
                XCTAssertEqual(fetchedAuction?.settled, expectedAuction.settled)
                XCTAssertEqual(fetchedAuction?.bids, expectedAuction.bids)
                
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
    
    func testFetchAuctionsFailed() {
        
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
        nounsProvider.fetchAuctions(settled: true)
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
