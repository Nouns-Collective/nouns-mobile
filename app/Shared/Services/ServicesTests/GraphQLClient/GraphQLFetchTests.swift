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
//    client = ApolloGraphQLClient(apolloClient: mockApolloClient)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    mockApolloClient.reset()
  }
  
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
  
  func testSuccessfulResponse() throws {
    let expectation = XCTestExpectation(description: "Did Complete")
    let expectation1 = XCTestExpectation(description: "Did Recieve Value")
        
    var subscriptions = Set<AnyCancellable>()
    
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    
    let mockApolloClient = MockApolloClient()
    mockApolloClient.set(result: MockResponses.mockNounsList(), error: nil)
    
    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
    
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
      .sink(receiveCompletion: { completion in
        print("completion: \(completion)")
      }, receiveValue: { list in
        print("value")
        expectation1.fulfill()
      }).store(in: &subscriptions)
    
    wait(for: [expectation1], timeout: 1.0)
  }
  
}
