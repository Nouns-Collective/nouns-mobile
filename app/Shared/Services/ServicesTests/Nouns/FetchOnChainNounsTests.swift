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
    // given
    let data = Fixtures.data(contentOf: "NounsListResponse", withExtension: "json")
    let graphQLClient = MockGraphQLClient(data: data)
    let nounsProvider = NounSubgraphProvider(graphQLClient: graphQLClient)
    
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
        fetchExpectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }
  
  func testFetchOnChainNounsFailure() {
    // given
    let graphQLClient = MockGraphQLClient(error: QueryError.badQuery)
    let nounsProvider = NounSubgraphProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
      .sink { completion in
        if case .failure(_) = completion {
          XCTAssertTrue(Thread.isMainThread)
          fetchExpectation.fulfill()
        }
      } receiveValue: { nouns in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }
}
