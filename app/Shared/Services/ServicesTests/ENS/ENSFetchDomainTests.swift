//
//  ENSFetchDomainTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
import Combine
@testable import Services

final class ENSFetchDomainTests: XCTestCase {
  static let token = "0x2573c60a6d127755aa2dc85e342f7da2378a0cc5"

  func testENSFetchDomain() throws {
    // given
    let data = Fixtures.data(contentOf: "ENSDomainResponse", withExtension: "json")
    let graphQLClient = MockGraphQLClient(data: data)
    let ensProvider = TheGraphEnsProvider(graphQLClient: graphQLClient)
    
    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    ensProvider.fetchDomain(token: ENSFetchDomainTests.token)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished")
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { domain in
        XCTAssertTrue(Thread.isMainThread)
        fetchExpectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [fetchExpectation], timeout: 1.0)
  }

  func testENSFetchDomainFailure() {
    // given
    let graphQLClient = MockGraphQLClient(error: QueryError.badQuery)
    let ensProvider = TheGraphEnsProvider(graphQLClient: graphQLClient)

    var cancellables = Set<AnyCancellable>()
    let fetchExpectation = expectation(description: #function)
    
    // when
    ensProvider.fetchDomain(token: ENSFetchDomainTests.token)
      .sink { completion in
        if case .failure(_) = completion {
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
