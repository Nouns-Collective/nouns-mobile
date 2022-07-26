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
import CoreData
@testable import Services

final class AutoStoreFetcherTests: XCTestCase {
  
  private static let dataModelName = "Nouns"
  
  private var persistentContainer: PersistentContainer!
  
  override func setUpWithError() throws {
    persistentContainer = PersistentContainer(name: Self.dataModelName, inMemory: true)
    persistentContainer.loadPersistentStores { _, error in
      guard let error = error else {
        return
      }
      XCTFail("Clouldn't load store \(error)")
    }
  }
  
  func testAutoStoreFetcherInit() throws {
    // given
    let fakeNoun = Noun.fixture()
    let viewContext = persistentContainer.newBackgroundContext()
    _ = try NounManagedObject.insert(into: viewContext, noun: fakeNoun)
    try viewContext.save()
    
    // when
    let autoStoreFetcher = try AutoStoreFetcher<NounManagedObject>(
      viewContext: viewContext,
      sortKeyPath: \NounManagedObject.createdAt
    )
    
    // then
    let fetchedNoun = autoStoreFetcher.fetchedObjects.first
    
    XCTAssertTrue(Thread.isMainThread)
    XCTAssertEqual(fetchedNoun?.id, fakeNoun.id)
    XCTAssertEqual(fetchedNoun?.name, fakeNoun.name)
    XCTAssertEqual(fetchedNoun?.createdAt, fakeNoun.createdAt)
    XCTAssertEqual(fetchedNoun?.updatedAt, fakeNoun.updatedAt)
    XCTAssertEqual(fetchedNoun?.owner.id, fakeNoun.owner.id)
    XCTAssertEqual(fetchedNoun?.seed.background, Int32(fakeNoun.seed.background))
    XCTAssertEqual(fetchedNoun?.seed.accessory, Int32(fakeNoun.seed.accessory))
    XCTAssertEqual(fetchedNoun?.seed.head, Int32(fakeNoun.seed.head))
    XCTAssertEqual(fetchedNoun?.seed.body, Int32(fakeNoun.seed.body))
    XCTAssertEqual(fetchedNoun?.seed.glasses, Int32(fakeNoun.seed.glasses))
  }
  
  func testAutoStoreFetcherUpdateOnDelayedObjectInsertion() throws {
    // given
    let viewContext = persistentContainer.newBackgroundContext()
    let autoStoreFetcher = try AutoStoreFetcher<NounManagedObject>(
      viewContext: viewContext,
      sortKeyPath: \NounManagedObject.createdAt
    )
    
    let expectation = expectation(description: #function)
    
    // when
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      
      let fakeNoun = Noun.fixture()
      _ = try? NounManagedObject.insert(into: viewContext, noun: fakeNoun)
      try? viewContext.save()
      
      
      let fetchedNoun = autoStoreFetcher.fetchedObjects.first
      
      XCTAssertTrue(Thread.isMainThread)
      XCTAssertEqual(fetchedNoun?.id, fakeNoun.id)
      XCTAssertEqual(fetchedNoun?.name, fakeNoun.name)
      XCTAssertEqual(fetchedNoun?.createdAt, fakeNoun.createdAt)
      XCTAssertEqual(fetchedNoun?.updatedAt, fakeNoun.updatedAt)
      XCTAssertEqual(fetchedNoun?.owner.id, fakeNoun.owner.id)
      XCTAssertEqual(fetchedNoun?.seed.background, Int32(fakeNoun.seed.background))
      XCTAssertEqual(fetchedNoun?.seed.accessory, Int32(fakeNoun.seed.accessory))
      XCTAssertEqual(fetchedNoun?.seed.head, Int32(fakeNoun.seed.head))
      XCTAssertEqual(fetchedNoun?.seed.body, Int32(fakeNoun.seed.body))
      XCTAssertEqual(fetchedNoun?.seed.glasses, Int32(fakeNoun.seed.glasses))
      
      expectation.fulfill()
    }
    
    // then
    wait(for: [expectation], timeout: 1.0)
  }
}
