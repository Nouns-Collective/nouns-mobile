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
    
    enum MockDataGraphQLResponder: MockGraphQLResponder {
        static func respond() throws -> Data {
            Data()
        }
    }
    
    // given
    let graphQLClient = MockGraphQLClient<MockDataGraphQLResponder>()
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
        
        fetchExpectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }
  
  func testFetchOnChainNounsFailure() {
    
    enum MockFailureGraphQLResponder: MockGraphQLResponder {
        static func respond() throws -> Data {
          throw QueryError.noData
        }
    }
    
    // given
    let graphQLClient = MockGraphQLClient<MockFailureGraphQLResponder>()
    let nounsProvider = NounSubgraphProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertTrue(Thread.isMainThread)
          
          fetchExpectation.fulfill()
        }
      } receiveValue: { domain in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }
}
