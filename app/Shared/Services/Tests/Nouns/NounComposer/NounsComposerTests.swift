//
//  NounsComposerTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 23.10.21.
//

import XCTest
@testable import Services

final class NounsComposerTests: XCTestCase {
  
    func testDefaultInitilizerLoadTraits() throws {
        let composer = OfflineNounComposer.default()
        
        XCTAssertFalse(composer.backgroundColors.isEmpty)
        XCTAssertFalse(composer.palette.isEmpty)
        XCTAssertFalse(composer.heads.isEmpty)
        XCTAssertFalse(composer.bodies.isEmpty)
        XCTAssertFalse(composer.glasses.isEmpty)
        XCTAssertFalse(composer.accessories.isEmpty)
    }
    
    func testNounTraitsParsedSuccessfully() throws {
        let url = try XCTUnwrap(Bundle.module.url(
            forResource: "fake-encoded-traits",
            withExtension: "json"))
        
        let composer = try OfflineNounComposer(encodedLayersURL: url)
        
        XCTAssertEqual(composer.palette, ["ffffff"])
        XCTAssertEqual(composer.backgroundColors, ["d5d7e1"])
        XCTAssertEqual(composer.accessories, [Trait.accessoryFixture])
        XCTAssertEqual(composer.heads, [Trait.headFixture])
        XCTAssertEqual(composer.bodies, [Trait.bodyFixture])
        XCTAssertEqual(composer.glasses, [Trait.glassesFixture])
    }
}
