//
//  FetchENSDomainHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
import Combine
@testable import Services

final class FetchENSDomainHitRealBackendTests: XCTestCase {
    
    fileprivate static let token = "0x0000044a32f0964f4bf8fb4d017e230ad33595c0e149b6b2d0c34b733dcf906a"
    
    func testFetchENSDomainHitRealBackend() throws {
        // given
        let query = ENSSubgraph.DomainLookupQuery(token: Self.token)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
            .receive(on: DispatchQueue.main)
            .compactMap { (page: Page<[ENSDomain]>) in
                return page.data.first?.name
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished ", #function)
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
                
            } receiveValue: { (domain: String) in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNotNil(domain)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
}
