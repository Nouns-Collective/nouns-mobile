//
//  FetchProposalsTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
import Combine
@testable import Services

final class FetchProposalsTests: XCTestCase {
  
  func testFetchProposalsSucceed() throws {
    
    enum MockDataGraphQLResponder: MockGraphQLResponder {
        static func respond() throws -> Data {
            Data()
        }
    }
    
    // given
    let graphQLClient = MockGraphQLClient<MockDataGraphQLResponder>()
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let ensFetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.liveAuctionStateDidChange()
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished")
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { nouns in
        XCTAssertTrue(Thread.isMainThread)
        
        ensFetchExpectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [ensFetchExpectation], timeout: 1.0)
  }
  
  func testFetchProposalsFailure() {
    
    enum MockFailureGraphQLResponder: MockGraphQLResponder {
        static func respond() throws -> Data {
          throw QueryError.noData
        }
    }
    
    // given
    let graphQLClient = MockGraphQLClient<MockFailureGraphQLResponder>()
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let ensFetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.liveAuctionStateDidChange()
      .sink { completion in
        if case let .failure(error) = completion {
          
          ensFetchExpectation.fulfill()
        }
      } receiveValue: { domain in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [ensFetchExpectation], timeout: 1.0)
  }
}
