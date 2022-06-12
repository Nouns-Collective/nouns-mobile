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

final class OffChainDeleteNounTests: XCTestCase {
  
  private static let dataModelName = "Nouns"
  
  func testOffChainDeleteNounSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun = Noun.fixture()
    try service.store(noun: fakeNoun)
    
    // Check if the noun was inserted to the store.
    var nouns = try service.fetchNouns()
    XCTAssertFalse(nouns.isEmpty)
    
    // when
    try service.delete(noun: fakeNoun)
    
    // then
    nouns = try service.fetchNouns()
    XCTAssertTrue(nouns.isEmpty)
  }
}
