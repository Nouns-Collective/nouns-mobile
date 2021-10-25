////
////  LiveAuctionStateDidChangeTests.swift
////  ServicesTests
////
////  Created by Ziad Tamim on 21.10.21.
////
//
//import XCTest
//import Combine
//@testable import Services
//
//final class LiveAuctionStateDidChangeTests: XCTestCase {
//  
//  func testLiveAuctionStateDidChange() throws {
//    
//    enum MockDataGraphQLResponder: MockGraphQLResponder {
//        static func respond() throws -> Data {
//            Data()
//        }
//    }
//    
//    // given
//    let graphQLClient = MockGraphQLClient<MockDataGraphQLResponder>()
//    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
//    
//    let expectation = expectation(description: #function)
//    
//    // when
//    let cancellable = nounsProvider.liveAuctionStateDidChange()
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
//    
//    // then
//    wait(for: [expectation], timeout: 1.0)
//    cancellable.cancel()
//  }
//  
//  func testLiveAuctionStateDidChangeFailure() {
//    
//    enum MockFailureGraphQLResponder: MockGraphQLResponder {
//        static func respond() throws -> Data {
//          throw QueryError.noData
//        }
//    }
//    
//    // given
//    let graphQLClient = MockGraphQLClient<MockFailureGraphQLResponder>()
//    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
//    
//    let expectation = expectation(description: #function)
//    
//    // when
//    let cancellable = nounsProvider.liveAuctionStateDidChange()
//      .sink { completion in
//        if case let .failure(error) = completion {
//          
//          expectation.fulfill()
//        }
//      } receiveValue: { domain in
//        XCTFail("💥 result unexpected")
//      }
//    
//    // then
//    wait(for: [expectation], timeout: 1.0)
//    cancellable.cancel()
//  }
//}
