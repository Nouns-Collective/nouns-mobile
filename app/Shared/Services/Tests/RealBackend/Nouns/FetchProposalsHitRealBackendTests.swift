//
//  FetchProposalsHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
import Combine
@testable import Services

final class FetchProposalsHitRealBackendTests: XCTestCase {
    
    func testFetchProposalsHitRealBackend() throws {
        // given
        let query = NounsSubgraph.ProposalsQuery(first: 1, skip: 0)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            .receive(on: DispatchQueue.main)
            .compactMap { (page: Page<[Proposal]>) in
                return page.data
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished ", #function)
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { (proposals: [Proposal]) in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertFalse(proposals.isEmpty)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
    
}
