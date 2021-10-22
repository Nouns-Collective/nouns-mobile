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
  var client: ApolloGraphQLClient!
  var mockApolloClient: MockApolloClient = MockApolloClient()

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    client = ApolloGraphQLClient(apolloClient: mockApolloClient)
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    mockApolloClient.reset()
  }
  
  func testBadServerResponseError() throws {
    let expectation = XCTestExpectation(description: "Did Complete")
    let expectation1 = XCTestExpectation(description: "Did Recieve Value")
    
    expectation1.isInverted = true
    
    let expectedError = URLError(.badServerResponse)
    
    let query = MockQuery<NounsListQuery, NounsList>(query: NounsListQuery())
    mockApolloClient.result = nil
    mockApolloClient.error = expectedError
    
    _ = client.fetch(query, cachePolicy: .returnCacheDataAndFetch)
      .sink { completion in
        XCTAssertEqual(completion, .failure(QueryError.request(error: expectedError)))
        expectation.fulfill()
      } receiveValue: { value in
        expectation1.fulfill()
      }
    
    wait(for: [expectation, expectation1], timeout: 1.0)
  }
  
}
