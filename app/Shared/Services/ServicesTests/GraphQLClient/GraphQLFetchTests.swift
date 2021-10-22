//
//  GraphQLFetchTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 20.10.21.
//

import XCTest
import Services
import Combine
import Apollo

class GraphQLFetchTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  /// Tests a bad server response
  func testBadServerResponseError() throws {
    let expectation = XCTestExpectation(description: "Did Complete")
    let expectation1 = XCTestExpectation(description: "Did Recieve Value")
    expectation1.isInverted = true

    let expectedError = URLError(.badServerResponse)

    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(result: nil, error: expectedError)
    
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)

    _ = client.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .sink { completion in
        XCTAssertEqual(completion, .failure(QueryError.request(error: expectedError)))
        expectation.fulfill()
      } receiveValue: { value in
        expectation1.fulfill()
      }

    wait(for: [expectation, expectation1], timeout: 1.0)
  }
  
  /// Tests a successful request and response against the GraphQL client
  func testSuccessfulResponse() throws {
    let expectation = XCTestExpectation(description: "Did Recieve Value")
        
    var subscriptions = Set<AnyCancellable>()
    
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(result: .init(data: MockResponses.mockNounsList(), errors: nil, source: .server), error: nil)
    
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
    
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink(receiveCompletion: { _ in
        // Leave intentionally blank
      }, receiveValue: { list in
        expectation.fulfill()
      }).store(in: &subscriptions)
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests when errors are returned from Apollo-related tasks
  func testGraphQLErrors() throws {
    let expectation = XCTestExpectation(description: "Did Complete")
    let expectation1 = XCTestExpectation(description: "Did Recieve Value")
    expectation1.isInverted = true
    
    var subscriptions = Set<AnyCancellable>()
    
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    
    let errors: [GraphQLError] = [GraphQLError(["description": "test description for error one"]),
                                  GraphQLError(["description": "test description for error two"])]
    
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(result: .init(data: nil, errors: errors, source: .server), error: nil)
    
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
    
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink(receiveCompletion: { completion in
        XCTAssertEqual(completion, .failure(errors.queryError()))
        expectation.fulfill()
      }, receiveValue: { list in
        expectation1.fulfill()
      }).store(in: &subscriptions)
    
    wait(for: [expectation, expectation1], timeout: 1.0)
  }
  
  /// Tests when there are no errors, but when data is nil
  func testNoDataError() throws {
    let expectation = XCTestExpectation(description: "Did complete")
    let expectation1 = XCTestExpectation(description: "Did Recieve Value")
    expectation1.isInverted = true
    
    var subscriptions = Set<AnyCancellable>()
    
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
        
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(result: .init(data: nil, errors: nil, source: .server), error: nil)
    
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
    
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink(receiveCompletion: { completion in
        expectation.fulfill()
        XCTAssertEqual(completion, .failure(QueryError.noData))
      }, receiveValue: { list in
        expectation1.fulfill()
      }).store(in: &subscriptions)
    
    wait(for: [expectation, expectation1], timeout: 1.0)
  }
}
