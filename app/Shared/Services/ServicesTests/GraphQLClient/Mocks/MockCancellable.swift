//
//  MockCancellable.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation
import Apollo

class MockCancellable: Apollo.Cancellable {
  init(closure: @escaping () -> Void) {
    closure()
  }

  func cancel() {}
}
