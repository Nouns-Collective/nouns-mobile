//
//  OffChainFetchStoredNounsTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 31.12.21.
//

import XCTest
@testable import Services

final class OffChainFetchStoredNounsTests: XCTestCase {

  private static let dataModelName = "Nouns"
  
  func testOffChainFecthNounsInAscendingOrder() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "FakeNoun1", createdAt: .now)
    let fakeNoun2 = Noun.fixture(id: "2", name: "FakeNoun2", createdAt: .now + 1)
    let fakeNoun3 = Noun.fixture(id: "3", name: "FakeNoun3", createdAt: .now + 2)
    
    try service.store(noun: fakeNoun1)
    try service.store(noun: fakeNoun2)
    try service.store(noun: fakeNoun3)
    
    // when
    let nouns = try service.fetchNouns()
    
    // then
    XCTAssertFalse(nouns.isEmpty)
    XCTAssertEqual(nouns, [fakeNoun1, fakeNoun2, fakeNoun3])
  }

  func testOffChainFecthNounsInDescendingOrder() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "FakeNoun1", createdAt: .now)
    let fakeNoun2 = Noun.fixture(id: "2", name: "FakeNoun2", createdAt: .now + 1)
    let fakeNoun3 = Noun.fixture(id: "3", name: "FakeNoun3", createdAt: .now + 2)
    
    try service.store(noun: fakeNoun1)
    try service.store(noun: fakeNoun2)
    try service.store(noun: fakeNoun3)
    
    // when
    let nouns = try service.fetchNouns(ascending: false)
    
    // then
    XCTAssertFalse(nouns.isEmpty)
    XCTAssertEqual(nouns, [fakeNoun3, fakeNoun2, fakeNoun1])
  }
}
