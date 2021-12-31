//
//  StoreNounTests.swift
//  
//
//  Created by Ziad Tamim on 30.12.21.
//

import XCTest
@testable import Services

final class OffChainStoreNounTests: XCTestCase {
  
  private static let dataModelName = "Nouns"
  
  func testOffChainStoreNounSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataNounsProvider(persistentContainer: persistentContainer)
    
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
    let service = CoreDataNounsProvider(persistentContainer: persistentContainer)
    
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
    let service = CoreDataNounsProvider(persistentContainer: persistentContainer)
    
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
    let service = CoreDataNounsProvider(persistentContainer: persistentContainer)
    
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
