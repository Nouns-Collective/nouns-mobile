//
//  GraphQLSubsciptionTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 20.10.21.
//

import XCTest
import Combine
import Apollo
@testable import Services

final class GraphQLClientSubsciptionTests: XCTestCase {
  
  /// Tests a successful request and response against the GraphQL client
  func testGraphQLClientSubscriptionSucceed() throws {
//    // given
//    let subscriptionResult = MockApolloClient.MockSubscriptionResult(
//      data: [
//        AuctionSubscription.Data(auctions: [.init(id: GraphQLID("1"), amount: "0", startTime: "100", endTime: "120", settled: false)]),
//        AuctionSubscription.Data(auctions: [.init(id: GraphQLID("1"), amount: "0", startTime: "100", endTime: "120", settled: false)])
//      ],
//      errors: nil
//    )
//    // TODO: - Replace response data with fixtures
//    let mockApolloClient = MockApolloClient()
//    mockApolloClient.set(subscriptionResult: subscriptionResult, error: nil)
//    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
//    let subscription = MockSubscription<AuctionSubscription, AuctionList>(subscription: AuctionSubscription())
//
//    var cancellables = Set<AnyCancellable>()
//    let expectation = expectation(description: #function)
//    expectation.expectedFulfillmentCount = 2
//
//    // when
//    client.subscription(subscription)
//      .sink { completion in
//        switch completion {
//        case .finished:
//          print("Finished")
//        case let .failure(error):
//          XCTFail("💥 Something went wrong: \(error)")
//        }
//      } receiveValue: { nouns in
//        XCTAssertTrue(Thread.isMainThread)
//
//        expectation.fulfill()
//      }
//      .store(in: &cancellables)
//
//    // then
//    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests a bad server response
  func testGraphQLClientSubscriptionFailureWithBadServerError() throws {
//    // given
//    let expectedError = URLError(.badServerResponse)
//    let subscription = MockSubscription<AuctionSubscription, AuctionList>(
//      subscription: AuctionSubscription()
//    )
//    let mockApolloClient = MockApolloClient()
//    mockApolloClient.set(subscriptionResult: nil, error: expectedError)
//    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
//
//    var cancellables = Set<AnyCancellable>()
//    let expectation = expectation(description: #function)
//
//    // when
//    client.subscription(subscription)
//      .sink { completion in
//        if case let .failure(error) = completion {
//          XCTAssertTrue(Thread.isMainThread)
//          XCTAssertEqual(error, QueryError.request(error: expectedError))
//
//          expectation.fulfill()
//        }
//      } receiveValue: { domain in
//        XCTFail("💥 result unexpected")
//      }
//      .store(in: &cancellables)
//
//    // then
//    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests when errors are returned from Apollo-related tasks
  func testGraphQLClientSubscriptionFailureWithErrors() throws {
//    // given
//    let errors = [
//      GraphQLError(["description": "test description for error one"]),
//      GraphQLError(["description": "test description for error two"]),
//    ]
//
//    let mockApolloClient = MockApolloClient()
//    mockApolloClient.set(subscriptionResult: .init(data: nil, errors: errors), error: nil)
//    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
//    let subscription = MockSubscription<AuctionSubscription, AuctionList>(subscription: AuctionSubscription())
//
//    var cancellables = Set<AnyCancellable>()
//    let expectation = expectation(description: #function)
//
//    // when
//    client.subscription(subscription)
//      .sink { completion in
//        if case let .failure(error) = completion {
//          XCTAssertTrue(Thread.isMainThread)
//          XCTAssertEqual(error, errors.queryError())
//
//          expectation.fulfill()
//        }
//      } receiveValue: { domain in
//        XCTFail("💥 result unexpected")
//      }
//      .store(in: &cancellables)
//
//    // then
//    wait(for: [expectation], timeout: 1.0)
  }
  
  /// Tests when there are no errors, but when data is nil
  func testGraphQLClientSubscriptionFailureWithNoDataError() throws {
//    // given
//    let mockApolloClient = MockApolloClient()
//    mockApolloClient.set(subscriptionResult: .init(data: nil, errors: nil), error: nil)
//    let client = ApolloGraphQLClient(apolloClient: mockApolloClient)
//    let subscription = MockSubscription<AuctionSubscription, AuctionList>(subscription: AuctionSubscription())
//    
//    var cancellables = Set<AnyCancellable>()
//    let expectation = expectation(description: #function)
//    
//    // when
//    client.subscription(subscription)
//      .sink { completion in
//        if case let .failure(error) = completion {
//          XCTAssertTrue(Thread.isMainThread)
//          XCTAssertEqual(error, QueryError.noData)
//          
//          expectation.fulfill()
//        }
//      } receiveValue: { domain in
//        XCTFail("💥 result unexpected")
//      }
//      .store(in: &cancellables)
//    
//    // then
//    wait(for: [expectation], timeout: 1.0)
  }
  
}
