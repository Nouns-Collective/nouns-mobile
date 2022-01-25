//
//  FetchNounActivitiesTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
@testable import Services

final class FetchNounActivitiesTests: XCTestCase {
  
  func testFetchNounActivitiesSucceed() async throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        Fixtures.data(contentOf: "nouns-activities-response-valid", withExtension: "json")
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
    
    let votes = try await nounsProvider.fetchActivity(for: "0", limit: 20, after: 0).data
    
    XCTAssertFalse(votes.isEmpty)
    
    let fetchedVote = votes.first
    let expectedVote = Vote.fixture
    
    XCTAssertEqual(fetchedVote?.supportDetailed, expectedVote.supportDetailed)
    XCTAssertEqual(fetchedVote?.proposal.id, expectedVote.proposal.id)
    XCTAssertEqual(fetchedVote?.proposal.title, expectedVote.proposal.title)
    XCTAssertEqual(fetchedVote?.proposal.description, expectedVote.proposal.description)
    XCTAssertEqual(fetchedVote?.proposal.status, expectedVote.proposal.status)
  }
  
  func testFetchNounActivitiesFailure() async {
    
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
      // when
      _ = try await nounsProvider.fetchActivity(for: "0", limit: 20, after: 0)
      
      XCTFail("💥 result unexpected")
    } catch {
      
    }
  }
}
