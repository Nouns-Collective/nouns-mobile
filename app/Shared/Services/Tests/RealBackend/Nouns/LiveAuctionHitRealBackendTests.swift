//
//  LiveAuctionHitRealBackendTests.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import XCTest
import Combine
@testable import Services

final class LiveAuctionHitRealBackendTests: XCTestCase {
    
    func testLiveAuctionSubscriptionHitRealBackend() throws {
        // given
        let nounsProvider = TheGraphNounsProvider()
        
        let expectation = expectation(description: #function)
        var subscriptions = Set<AnyCancellable>()
        
        // when
        nounsProvider.liveAuctionStateDidChange()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished ", #function)
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { auction in
                XCTAssertTrue(Thread.isMainThread)
                print(auction)
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5.0)
    }
}
