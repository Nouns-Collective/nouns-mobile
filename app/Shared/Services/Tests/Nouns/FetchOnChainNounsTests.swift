//
//  FetchOnChainNounsTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
@testable import Services

final class FetchOnChainNounsTests: XCTestCase {
  
  func testFetchOnChainNounsSucceed() async throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        Fixtures.data(contentOf: "on-chain-nouns-response-valid", withExtension: "json")
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    // when
    let nouns = try await nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
    
    // then
    XCTAssertFalse(nouns.isEmpty)
    
    let fetchNoun = nouns.first
    let expectedNoun = Noun.fixture
    
    XCTAssertEqual(fetchNoun?.id, expectedNoun.id)
    XCTAssertEqual(fetchNoun?.owner, expectedNoun.owner)
    XCTAssertEqual(fetchNoun?.seed, expectedNoun.seed)
  }
  
  func testFetchOnChainNounsFailure() async {
    
    enum MockErrorURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        throw QueryError.badQuery
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    do {
      _ = try await nounsProvider.fetchOnChainNouns(limit: 10, after: 0)
      XCTFail("💥 result unexpected")
      
    } catch {
      
    }
  }
}
