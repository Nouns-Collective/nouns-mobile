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

final class CloudConfigurationTests: XCTestCase {
    
    func testCloudConfigurationNounQueryURL() {
        let expectedURL = URL(string: "https://api.goldsky.com/api/public/project_cldf2o9pqagp43svvbk5u3kmo/subgraphs/nouns/0.2.0/gn")
        XCTAssertEqual(CloudConfiguration.Nouns.query.url, expectedURL)
    }
    
    func testCloudConfigurationNounSubcriptionURL() {
        let expectedURL = URL(string: "wss://api.goldsky.com/api/public/project_cldf2o9pqagp43svvbk5u3kmo/subgraphs/nouns/0.2.0/gn")
        XCTAssertEqual(CloudConfiguration.Nouns.subscription.url, expectedURL)
    }
    
    func testCloudConfigurationENSSubcriptionURL() {
        let expectedURL = URL(string: "https://api.thegraph.com/subgraphs/name/ensdomains/ens")
        XCTAssertEqual(CloudConfiguration.ENS.query.url, expectedURL)
    }
}
