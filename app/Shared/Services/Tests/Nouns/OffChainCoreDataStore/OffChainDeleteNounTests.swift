//
//  OffChainDeleteNounTests.swift
//  
//
//  Created by Ziad Tamim on 31.12.21.
//

import XCTest
@testable import Services

final class OffChainDeleteNounTests: XCTestCase {
  
  private static let dataModelName = "Nouns"
  
  func testOffChainDeleteNounSuccessfully() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataNounsProvider(persistentContainer: persistentContainer)
    
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
