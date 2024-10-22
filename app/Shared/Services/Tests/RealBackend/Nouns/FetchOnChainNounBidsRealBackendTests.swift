// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

final class FetchBidsHitRealBackendTests: XCTestCase {
    
    func testFetchBidsHitRealBackend() async throws {
        // given
        let query = NounsSubgraph.BidsQuery(nounID: "99", limit: 20, skip: 0)
        let networkingClient = URLSessionNetworkClient(urlSession: URLSession.shared)
        let client = GraphQLClient(networkingClient: networkingClient)
        
        // when
        let page: Page<[Bid]> = try await client.fetch(query, cachePolicy: .fetchIgnoringCacheData)
        
        // then
        XCTAssertFalse(page.data.isEmpty)
    }
}
