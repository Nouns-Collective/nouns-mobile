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
        let expectedWeiValue = "100000000000000000000" // represented as a string
        
        let formatter = EtherFormatter(from: .eth)
        formatter.unit = .wei
        let result = formatter.string(from: ethValue)
        
        XCTAssertEqual(result, expectedWeiValue)
    }
    
    /// Tests converting from WEI to ETH
    func testConvertingFromWeiToEth() throws {
        // given
        let weiValue = "100000000000000000000"
        let expectedEthValue = "100" // represented as a string
        
        let formatter = EtherFormatter(from: .wei)
        formatter.unit = .eth
        let result = formatter.string(from: weiValue)
        
        XCTAssertEqual(result, expectedEthValue)
    }
    
    /// Tests behaviour if string does not only contain digits but also has other characters such as a decimal.
    /// The response should be nil in this case
    func testConvertingWithDecimalResultsInNil() throws {
        // given
        let weiValue = "100000000000000000000.0"
        
        let formatter = EtherFormatter(from: .wei)
        formatter.unit = .eth
        let result = formatter.string(from: weiValue)
        
        XCTAssertNil(result)
    }
}

