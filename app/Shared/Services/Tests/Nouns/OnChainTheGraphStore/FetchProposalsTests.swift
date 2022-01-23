//
//  FetchProposalsTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
@testable import Services

final class FetchProposalsTests: XCTestCase {
    
    func testFetchProposalsSucceed() async throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                Fixtures.data(contentOf: "proposal-list-response-valid", withExtension: "json")
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let graphQLClient = GraphQLClient(networkingClient: client)
        let nounsProvider = TheGraphNounsProvider(graphQLClient: graphQLClient)
        
        // then
        let proposals = try await nounsProvider.fetchProposals(limit: 10, after: 0).data
     
        // when
        XCTAssertFalse(proposals.isEmpty)
        
        let fetchProposal = proposals.first
        let expectProposal = Proposal.fixture
        
        XCTAssertEqual(fetchProposal?.id, expectProposal.id)
        XCTAssertEqual(fetchProposal?.title, expectProposal.title)
        XCTAssertEqual(fetchProposal?.description, expectProposal.description)
    }
    
    func testFetchProposalsFailure() async {
        
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
            _ = try await nounsProvider.fetchProposals(limit: 10, after: 0)
            XCTFail("💥 result unexpected")
        } catch {
            
        }
    }
}
