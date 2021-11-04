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
  static let token = "0x0000044a32f0964f4bf8fb4d017e230ad33595c0e149b6b2d0c34b733dcf906a"

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
