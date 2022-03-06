//
//  OffChainNounsStoreDidChangeTests.swift
//  
//
//  Created by Ziad Tamim on 01.01.22.
//

import XCTest
@testable import Services

final class OffChainNounsStoreDidChangeTests: XCTestCase {

  private static let dataModelName = "Nouns"
  
  func testOffChainNounsStoreDidChangeInAscendingOrder() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "FakeNoun1", createdAt: .now)
    let fakeNoun2 = Noun.fixture(id: "2", name: "FakeNoun2", createdAt: .now + 1)
    let fakeNoun3 = Noun.fixture(id: "3", name: "FakeNoun3", createdAt: .now + 2)
    
    try service.store(noun: fakeNoun1)
    try service.store(noun: fakeNoun2)
    try service.store(noun: fakeNoun3)
    
    let expectation = expectation(description: #function)
    expectation.assertForOverFulfill = true
    
    Task {
      // when
      for try await nouns in service.nounsStoreDidChange() {
        
        // then
        XCTAssertFalse(nouns.isEmpty)
        XCTAssertEqual(nouns, [fakeNoun1, fakeNoun2, fakeNoun3])
        
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testOffChainNounsStoreDidChangeInDescendingOrder() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "FakeNoun1", createdAt: .now)
    let fakeNoun2 = Noun.fixture(id: "2", name: "FakeNoun2", createdAt: .now + 1)
    let fakeNoun3 = Noun.fixture(id: "3", name: "FakeNoun3", createdAt: .now + 2)
    
    try service.store(noun: fakeNoun1)
    try service.store(noun: fakeNoun2)
    try service.store(noun: fakeNoun3)
    
    let expectation = expectation(description: #function)
    expectation.assertForOverFulfill = true
    
    Task {
      // when
      for try await nouns in service.nounsStoreDidChange(ascendingOrder: false) {
        
        // then
        XCTAssertFalse(nouns.isEmpty)
        XCTAssertEqual(nouns, [fakeNoun3, fakeNoun2, fakeNoun1])
        
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testOffChainNounsStoreDidChangeDelayedInsertion() throws {
    // given
    let persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    let service = CoreDataOffChainNouns(persistentContainer: persistentContainer)
    
    let fakeNoun1 = Noun.fixture(id: "1", name: "FakeNoun1", createdAt: .now)
    let fakeNoun2 = Noun.fixture(id: "2", name: "FakeNoun2", createdAt: .now + 1)
    let fakeNoun3 = Noun.fixture(id: "3", name: "FakeNoun3", createdAt: .now + 2)
    
    let expectedNouns = [fakeNoun1, fakeNoun2, fakeNoun3]
    let expectation = expectation(description: #function)
    // It should expect 4 fulfillment as the initial fetch will be empty plus 3 insertion.
    expectation.expectedFulfillmentCount = 4
    expectation.assertForOverFulfill = true
    
    Task {
      // when
      for try await nouns in service.nounsStoreDidChange() {
        if nouns.count == expectedNouns.count {
          XCTAssertEqual(nouns, [fakeNoun1, fakeNoun2, fakeNoun3])
        }
        
        expectation.fulfill()
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      try? service.store(noun: fakeNoun1)
      try? service.store(noun: fakeNoun2)
      try? service.store(noun: fakeNoun3)
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
}
