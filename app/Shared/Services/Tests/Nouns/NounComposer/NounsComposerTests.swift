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
