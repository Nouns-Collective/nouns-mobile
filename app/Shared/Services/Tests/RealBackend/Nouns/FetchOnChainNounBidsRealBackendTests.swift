//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import XCTest
import Combine
@testable import Services

final class FetchBidsHitRealBackendTests: XCTestCase {
    
    func testFetchBidsHitRealBackend() throws {
        // given
        let query = NounsSubgraph.BidsQuery(nounID: "99")
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            .receive(on: DispatchQueue.main)
            .compactMap { (page: Page<[Bid]>) in
                return page.data
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished ", #function)
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { (bids: [Bid]) in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertFalse(bids.isEmpty)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
    
}

