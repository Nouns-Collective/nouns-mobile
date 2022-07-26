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
import Combine
@testable import Services
@testable import web3

final class FetchENSDomainHitRealBackendTests: XCTestCase {
    
    fileprivate static let token = "0x6e24ac7a957ba929e48e298c75f6b76d0cdfa901"
    
    func testFetchENSDomainHitRealBackend() async throws {
        // given
        let ethClient = EthereumClient(url: CloudConfiguration.Infura.mainnet.url!)
        let web3Client = Web3ENSProvider(ethereumClient: ethClient)
        
        let expectation = expectation(description: #function)
        
        // when
        do {
            _ = try await web3Client.domainLookup(address: FetchENSDomainHitRealBackendTests.token)
            expectation.fulfill()
        } catch {
            XCTFail("💥 Something went wrong: \(error)")
        }
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
}
