//
//  MockNetworkClient.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-25.
//

import Foundation
@testable import Services
import Combine

final class MockNetworkClient: NetworkingClient {
  var data: Data?
  var error: RequestError?
  
  init(data: Data) {
    self.data = data
    self.error = nil
  }
  
  init(error: RequestError) {
    self.data = nil
    self.error = error
  }
  
  func data(for request: NetworkRequest) -> AnyPublisher<Data, RequestError> {
    if let data = data {
      return Just(data)
        .setFailureType(to: RequestError.self)
        .eraseToAnyPublisher()
    } else if let error = error {
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    return Empty()
      .eraseToAnyPublisher()
  }
}
