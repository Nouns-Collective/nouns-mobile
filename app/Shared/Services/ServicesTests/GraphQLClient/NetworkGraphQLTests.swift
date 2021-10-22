//
//  NetworkGraphQLTests.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import XCTest
import Services
import Apollo
import ApolloWebSocket
import Combine

class NetworkGraphQLTests: XCTestCase {
  
  private struct TestURL {
    static let nounsSubgraphURL: URL? = {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"
      urlComponents.host = "api.thegraph.com"
      urlComponents.path = "/subgraphs/name/nounsdao/nouns-subgraph"
      return urlComponents.url
    }()
  }
  
  let store = ApolloStore()

  private(set) lazy var apollo: ApolloClient = ApolloClient(url: TestURL.nounsSubgraphURL!)
  
  lazy var client = ApolloGraphQLClient(apolloClient: apollo)
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testSampleQuery() throws {
    let expectation = XCTestExpectation(description: "Did compete")
    let expectation1 = XCTestExpectation(description: "Did receive value")

    var subscriptions = Set<AnyCancellable>()
    
    let query = NounsListGraphQuery()
    client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
    .sink { completion in
      expectation.fulfill()
    } receiveValue: { list in
      expectation1.fulfill()
      print("response: \(list as NounsList)")
    }.store(in: &subscriptions)
    
    wait(for: [expectation, expectation1], timeout: 10.0)
  }
}
