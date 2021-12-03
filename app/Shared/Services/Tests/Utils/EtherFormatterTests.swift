//
//  EtherFormatterTests.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-15.
//

import XCTest
import Combine
@testable import Services

final class EtherFormatterTests: XCTestCase {
    
    /// Tests converting from ETH to WEI
    func testConvertingFromEthToWei() throws {
        // given
        let ethValue = "100"
        // represented as a string
        let expectedWeiValue = "100000000000000000000"
        
        let formatter = EtherFormatter(from: .eth)
        formatter.unit = .wei
        let result = formatter.string(from: ethValue)
        
        XCTAssertEqual(result, expectedWeiValue)
    }
    
    /// Tests converting from WEI to ETH
    func testConvertingFromWeiToEth() throws {
        // given
        let weiValue = "2245320000000000000000"
        // represented as a string
        let expectedEthValue = "2245.32"
        
        let formatter = EtherFormatter(from: .wei)
        formatter.unit = .eth
        let result = formatter.string(from: weiValue)
        
        XCTAssertEqual(result, expectedEthValue)
    }
    
    /// Tests behaviour if string does containts any non-numeric characters
    /// The response should be nil in this case
    func testConvertingWithTextResultsInNil() throws {
        // given
        let weiValue = "sometext"
        
        let formatter = EtherFormatter(from: .wei)
        formatter.unit = .eth
        let result = formatter.string(from: weiValue)
        
        XCTAssertNil(result)
    }
}

