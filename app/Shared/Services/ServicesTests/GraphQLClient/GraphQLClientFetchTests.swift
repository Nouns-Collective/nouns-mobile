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
    /*
    // given
    let queryResult = MockApolloClient.MockQueryResult(
      data: MockResponses.mockNounsList(),
      errors: nil,
      source: .server
    )
    let graphQLClient = MockApolloClient()
    graphQLClient.set(queryResult: queryResult, error: nil)
    let client = ApolloGraphQLClient(apolloClient: graphQLClient)
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())

    let expectation = expectation(description: #function)
    var subscriptions = Set<AnyCancellable>()

    // when
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink { completion in
        switch completion {
        case .finished:
          print("Finished")
        case let .failure(error):
          XCTFail("💥 Something went wrong: \(error)")
        }
      } receiveValue: { nounsList in
        XCTAssertTrue(Thread.isMainThread)
        XCTAssertFalse(nounsList.nouns.isEmpty)

        expectation.fulfill()
      }
      .store(in: &subscriptions)

    // then
    wait(for: [expectation], timeout: 1.0)
     */
    fatalError("Implementation for \(#function) is missing")
  }
  
  /// Tests a bad server response
  func testGraphQLClientFetchQueryFailureWithBadServerResponseError() throws {
    /*
    // given
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(queryResult: nil, error: URLError(.badServerResponse))
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)

    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)

    // when
    client.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertTrue(Thread.isMainThread)
          XCTAssertEqual(error, .request(error: URLError(.badServerResponse)))

          expectation.fulfill()
        }

      } receiveValue: { value in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)

    // then
    wait(for: [expectation], timeout: 1.0)
     */
    fatalError("Implementation for \(#function) is missing")
  }
  
  /// Tests when errors are returned from Apollo-related tasks
  func testGraphQLClientFetchQueryFailureWithErrors() throws {
    /*
    // given
    let errors = [
      GraphQLError(["description": "test description for error one"]),
      GraphQLError(["description": "test description for error two"]),
    ]

    let queryResult = MockApolloClient.MockQueryResult(
      data: nil,
      errors: errors,
      source: .server
    )
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(queryResult: queryResult, error: nil)
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)

    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)

    // when
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertTrue(Thread.isMainThread)
          XCTAssertEqual(error, errors.queryError())

          expectation.fulfill()
        }
      } receiveValue: { domain in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)

    // then
    wait(for: [expectation], timeout: 1.0)
     */
    fatalError("Implementation for \(#function) is missing")
  }
  
  /// Tests when there are no errors, but when data is nil
  func testGraphQLClientFetchQueryFailureWithNoDataError() throws {
    /*
    // given
    let queryResult = MockApolloClient.MockQueryResult(
      data: nil,
      errors: nil,
      source: .server
    )
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(queryResult: queryResult, error: nil)
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
    
    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)
    
    // when
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertTrue(Thread.isMainThread)
          XCTAssertEqual(error, .noData)
          
          expectation.fulfill()
        }
      } receiveValue: { domain in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [expectation], timeout: 1.0)
     */
    fatalError("Implementation for \(#function) is missing")
  }
}
