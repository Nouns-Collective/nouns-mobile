//
//  GraphQLFetchTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 20.10.21.
//

import XCTest
import Combine
@testable import Services

final class GraphQLClientFetchTests: XCTestCase {
  
  /// Tests a successful request and response against the GraphQL client
  func testGraphQLClientFetchQuerySucceed() throws {
    // given
    let response = Fixtures.data(contentOf: "NounsListResponse", withExtension: "json")
    let networkClient = MockNetworkClient(data: response)
    let graphQLClient = GraphQL(networkingClient: networkClient)
    let query = NounsSubgraph.NounsListQuery(first: 10, skip: 0)

    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()

    // when
    graphQLClient.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished")
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { (response: HTTPResponse<Page<[Noun]>>) in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertFalse(response.data.data.isEmpty)

        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // then
    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests a bad server response
  func testGraphQLClientFetchQueryFailureWithBadServerResponseError() throws {
    // given
    let mockError = RequestError.request(error: URLError(.badServerResponse))
    let networkClient = MockNetworkClient(error: mockError)
    let graphQLClient = GraphQL(networkingClient: networkClient)
    let query = NounsSubgraph.NounsListQuery(first: 10, skip: 0)

    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()

    // when
    graphQLClient.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertTrue(Thread.isMainThread)
          XCTAssertEqual(error, .request(error: mockError))
          
          expectation.fulfill()
        }

      } receiveValue: { (response: HTTPResponse<Page<[Noun]>>) in
        XCTFail("💥 result unexpected")
      }
      .store(in: &subscriptions)

    // then
    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests a no data response
  func testGraphQLClientFetchQueryFailureWithNoDataError() throws {
    fatalError("Implementation for \(#function) missing")
  }
}
