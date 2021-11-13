//
//  FetchActivitiesHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

import XCTest
import Combine
@testable import Services

final class FetchActivitiesHitRealBackendTests: XCTestCase {
    
    func testFetchActivitiesHitRealBackend() throws {
        // given
        let query = NounsSubgraph.ActivitiesQuery(nounID: "0")
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            .receive(on: DispatchQueue.main)
            .compactMap { (page: Page<[Vote]>) in
                page.data
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished ", #function)
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { votes in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertFalse(votes.isEmpty)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
    
}
