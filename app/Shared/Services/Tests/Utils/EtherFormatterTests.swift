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

final class EtherFormatterTests: XCTestCase {

  /// Tests no conversion (eth to eth)
  func testNoConversion() {
    // given
    let ethValue = "100.23"
    // represented as a formatted string
    let expectedEthValue = "100.23"

    let formatter = EtherFormatter(from: .eth)
    let result = formatter.string(from: ethValue)

    XCTAssertEqual(result, expectedEthValue)
  }

  /// Tests the default number of digits after the decimal
  func testDefaultFractionalDigits() {
    // given
    let ethValue = "100.2345"
    // represented as a formatted string
    let expectedEthValue = "100.23"

    let formatter = EtherFormatter(from: .eth)
    let result = formatter.string(from: ethValue)

    XCTAssertEqual(result, expectedEthValue)
  }

  /// Tests the minimum number of digits after the decimal
  func testMinimumFractionalDigits() {
    // given
    let ethValue = "100"
    // represented as a formatted string
    let expectedEthValue = "100.0"

    let formatter = EtherFormatter(from: .eth)
    formatter.minimumFractionDigits = 1
    let result = formatter.string(from: ethValue)

    XCTAssertEqual(result, expectedEthValue)
  }

  /// Tests the maximum number of digits after the decimal
  func testMaximumFractionalDigits() {
    // given
    let ethValue = "100.2345"
    // represented as a formatted string
    let expectedEthValue = "100.234"

    let formatter = EtherFormatter(from: .eth)
    formatter.maximumFractionDigits = 3
    let result = formatter.string(from: ethValue)

    XCTAssertEqual(result, expectedEthValue)
  }

  /// Tests converting from ETH to WEI
  func testConvertingFromEthToWei() throws {
    // given
    let ethValue = "100"
    // represented as a string
    let expectedWeiValue = "100,000,000,000,000,000,000"
    
    let formatter = EtherFormatter(from: .eth)
    formatter.unit = .wei
    formatter.minimumFractionDigits = 0
    let result = formatter.string(from: ethValue)
    
    XCTAssertEqual(result, expectedWeiValue)
  }
  
  /// Tests converting from WEI to ETH
  func testConvertingFromWeiToEth() throws {
    // given
    let weiValue = "2245320000000000000000"
    // represented as a string
    let expectedEthValue = "2,245.32"
    
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
