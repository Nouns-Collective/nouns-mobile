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

  fileprivate static let token = "0x2573c60a6d127755aa2dc85e342f7da2378a0cc5"
  fileprivate static let domain = "example.eth"

  func testENSFetchDomain() throws {
    /*
     enum MockDataGraphQLResponder: MockGraphQLResponder {
     static func respond() throws -> Data {
     Data()
     }
     }
     
     // given
     let graphQLClient = MockGraphQLClient<MockDataGraphQLResponder>()
     let ens = TheGraphENSProvider(graphQLClient: graphQLClient)
     
     var cancellables = Set<AnyCancellable>()
     let ensFetchExpectation = expectation(description: #function)
     
     // when
     ens.fetchDomain(token: Self.token)
     .sink { completion in
     switch completion {
     case .finished:
     print("Finished")
     case let .failure(error):
     XCTFail("💥 Something went wrong: \(error)")
     }
     } receiveValue: { domain in
     XCTAssertTrue(Thread.isMainThread)
     XCTAssertEqual(domain, Self.domain)
     
     ensFetchExpectation.fulfill()
     }
     .store(in: &cancellables)
     
     // then
     wait(for: [ensFetchExpectation], timeout: 1.0)
     */
    fatalError("Implementation for \(#function) missing")
  }

  func testENSFetchDomainFailure() {
    /*
     enum MockFailureGraphQLResponder: MockGraphQLResponder {
     static func respond() throws -> Data {
     throw QueryError.noData
     }
     }
     
     // given
     let graphQLClient = MockGraphQLClient<MockFailureGraphQLResponder>()
     let ens = TheGraphENSProvider(graphQLClient: graphQLClient)
     
     var cancellables = Set<AnyCancellable>()
     let ensFetchExpectation = expectation(description: #function)
     
     // when
     ens.fetchDomain(token: Self.token)
     .sink { completion in
     if case let .failure(error) = completion {
     XCTAssertEqual(error, ENSError.noDomain)
     
     ensFetchExpectation.fulfill()
     }
     } receiveValue: { domain in
     XCTFail("💥 result unexpected")
     }
     .store(in: &cancellables)
     
     // then
     wait(for: [ensFetchExpectation], timeout: 1.0)
     }
     */
    fatalError("Implementation for \(#function) missing")
  }
}
