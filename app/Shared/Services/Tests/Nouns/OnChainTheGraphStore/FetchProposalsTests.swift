// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
        let nounsProvider = TheGraphOnChainNouns(graphQLClient: graphQLClient)
        
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
        let nounsProvider = TheGraphOnChainNouns(graphQLClient: graphQLClient)
        
        do {
            // when
            _ = try await nounsProvider.fetchProposals(limit: 10, after: 0)
            XCTFail("💥 result unexpected")
        } catch {
            
        }
    }
}
