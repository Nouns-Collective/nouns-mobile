//
//  NetworkGraphQLTests.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import XCTest
import Combine
@testable import Services

final class GraphQLClientHitRealBackendTests: XCTestCase {
  
  func testFetchOnChainNouns() throws {
    // given
    let query = NounsSubgraph.NounsListQuery(first: 10, skip: 0)
    let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
    let client = GraphQL(networkingClient: networkingClient)
    
    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()
    
    // when
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .receive(on: DispatchQueue.main)
      .compactMap { (responseData: HTTPResponse<Page<[Noun]>>) in
        return responseData.data.data
      }
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished ", #function)
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { (nouns: [Noun]) in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertFalse(nouns.isEmpty)
        expectation.fulfill()
      }
      .store(in: &subscriptions)
    
    // then
    wait(for: [expectation], timeout: 5.0)
  }
  
  func testLiveAuctionSubscription() throws {
    fatalError("Implementation for \(#function) missing")
  }
}
