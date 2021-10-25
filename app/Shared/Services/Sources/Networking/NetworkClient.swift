//
//  NetworkClient.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation
import Combine

public protocol NetworkingClient: AnyObject {
  /// Performs an HTTP request on a server
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - request: The request to perform on the server
  ///
  /// - Returns: A publisher emitting a `Data` type  instance. The publisher will emit on the *main* thread.
  func data(for request: NetworkRequest) -> AnyPublisher<Data, URLError>
}

public class URLSessionNetworkClient: NetworkingClient {
  private var urlSession: URLSession
  
  public init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  public func data(for request: NetworkRequest) -> AnyPublisher<Data, URLError> {
    urlSession.dataTaskPublisher(for: URLRequest(for: request))
      .map(\.data)
      .eraseToAnyPublisher()
  }
}
