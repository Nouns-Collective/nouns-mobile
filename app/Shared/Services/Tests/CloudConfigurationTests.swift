//
//  CloudConfigurationTests.swift
//  
//
//  Created by Ziad Tamim on 03.12.21.
//

import XCTest
@testable import Services

final class CloudConfigurationTests: XCTestCase {
    
    func testCloudConfigurationNounQueryURL() {
        let expectedURL = URL(string: "https://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph")
        XCTAssertEqual(CloudConfiguration.Nouns.query.url, expectedURL)
    }
    
    func testCloudConfigurationNounSubcriptionURL() {
        let expectedURL = URL(string: "wss://api.thegraph.com/subgraphs/name/nounsdao/nouns-subgraph")
        XCTAssertEqual(CloudConfiguration.Nouns.subscription.url, expectedURL)
    }
    
    func testCloudConfigurationENSSubcriptionURL() {
        let expectedURL = URL(string: "https://api.thegraph.com/subgraphs/name/ensdomains/ens")
        XCTAssertEqual(CloudConfiguration.ENS.query.url, expectedURL)
    }
}
