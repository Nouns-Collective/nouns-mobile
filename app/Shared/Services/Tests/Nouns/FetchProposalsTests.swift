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
    // given
    let data = Fixtures.data(contentOf: "ProposalListResponse", withExtension: "json")
    let graphQLClient = MockGraphQLClient(data: data)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.fetchProposals(limit: 10, after: 0)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished")
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { proposals in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertFalse(proposals.isEmpty)
        fetchExpectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }

  func testFetchProposalsFailure() {
    // given
    let graphQLClient = MockGraphQLClient(error: QueryError.badQuery)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    nounsProvider.fetchProposals(limit: 10, after: 0)
      .sink { completion in
        if case .failure(_) = completion {
          XCTAssertTrue(Thread.isMainThread)
          fetchExpectation.fulfill()
        }
      } receiveValue: { proposals in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }
}
