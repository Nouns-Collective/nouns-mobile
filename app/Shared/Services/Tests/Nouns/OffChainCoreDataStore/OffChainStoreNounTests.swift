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

final class OffChainStoreNounTests: XCTestCase {
  
  private static let dataModelName = "Nouns"
  
  func testOffChainStoreNounSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    // when
    let fakeNoun = Noun.fixture()
    try service.store(noun: fakeNoun)
    
    // then
    let nouns = try service.fetchNouns()
    XCTAssertFalse(nouns.isEmpty)
    XCTAssertEqual(nouns.last?.id, fakeNoun.id)
    XCTAssertEqual(nouns.last?.name, fakeNoun.name)
    XCTAssertEqual(nouns.last?.createdAt, fakeNoun.createdAt)
    XCTAssertEqual(nouns.last?.updatedAt, fakeNoun.updatedAt)
    XCTAssertEqual(nouns.last?.seed, fakeNoun.seed)
  }
  
  func testOffChainStoreMultipleNounsSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "fakeNoun1")
    let fakeNoun2 = Noun.fixture(id: "2", name: "fakeNoun2", createdAt: .now + 5.0)
    
    // when
    try service.store(noun: fakeNoun1)
    try service.store(noun: fakeNoun2)
    
    // then
    let nouns = try service.fetchNouns()
    XCTAssertFalse(nouns.isEmpty)
    XCTAssertEqual(nouns.count, 2)
    XCTAssertEqual(nouns, [fakeNoun1, fakeNoun2])
  }
  
  func testOffChainStoreUpdateNounSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    var fakeNoun1 = Noun.fixture(id: "1", name: "fakeNoun1")
    
    // when
    try service.store(noun: fakeNoun1)
    
    fakeNoun1.name = "Nouner"
    try service.store(noun: fakeNoun1)
    
    // then
    let nouns = try service.fetchNouns()
    XCTAssertEqual(nouns.last, fakeNoun1)
  }
  
  func testOffChainStoreUpdateUpdateNounsSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    var fakeNoun1 = Noun.fixture(id: "1", name: "fakeNoun1")
    var fakeNoun2 = Noun.fixture(id: "2", name: "fakeNoun2", createdAt: .now + 5.0)
    
    // when
    try service.store(noun: fakeNoun1)
    fakeNoun1.name = "Nouner1"
    try service.store(noun: fakeNoun1)
    
    try service.store(noun: fakeNoun2)
    fakeNoun2.name = "Nouner2"
    try service.store(noun: fakeNoun2)
    
    // then
    let nouns = try service.fetchNouns()
    XCTAssertFalse(nouns.isEmpty)
    XCTAssertEqual(nouns.count, 2)
    XCTAssertEqual(nouns, [fakeNoun1, fakeNoun2])
  }
}
