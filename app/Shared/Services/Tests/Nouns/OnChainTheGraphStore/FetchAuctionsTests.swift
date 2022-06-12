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

final class FetchAuctionsTests: XCTestCase {
  
  func testFetchAuctionsSucceed() async throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        Fixtures.data(contentOf: "auctions-response-valid", withExtension: "json")
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let nounsProvider = TheGraphOnChainNouns(graphQLClient: graphQLClient)
    
    // when
    let auctions = try await nounsProvider.fetchAuctions(settled: true, includeNounderOwned: false, limit: 10,
                                                         cursor: 0, sortDescending: true).data
    
    // then
    XCTAssertFalse(auctions.isEmpty)
    
    let expectedAuction = Auction.fixture()
    let fetchedAuction = auctions.first
    
    XCTAssertEqual(fetchedAuction?.id, expectedAuction.id)
    XCTAssertEqual(fetchedAuction?.startTime, expectedAuction.startTime)
    XCTAssertEqual(fetchedAuction?.endTime, expectedAuction.endTime)
    XCTAssertEqual(fetchedAuction?.settled, expectedAuction.settled)

    XCTAssertEqual(fetchedAuction?.noun.id, expectedAuction.noun.id)
    XCTAssertEqual(fetchedAuction?.noun.name, expectedAuction.noun.name)
    XCTAssertEqual(fetchedAuction?.noun.owner, expectedAuction.noun.owner)
    XCTAssertEqual(fetchedAuction?.noun.seed, expectedAuction.noun.seed)
  }
  
  func testFetchAuctionsFailed() async {
    
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
      _ = try await nounsProvider.fetchAuctions(settled: true, includeNounderOwned: false, limit: 10, cursor: 0, sortDescending: true)
      
      // when
      XCTFail("💥 result unexpected")
      
    } catch {
      
    }
  }
}
