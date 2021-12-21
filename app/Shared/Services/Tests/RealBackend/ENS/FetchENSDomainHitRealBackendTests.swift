//
//  FetchENSDomainHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

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
