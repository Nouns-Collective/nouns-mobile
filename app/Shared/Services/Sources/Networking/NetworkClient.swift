//
//  NetworkClient.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation
import Combine

public protocol NetworkingClient: AnyObject {
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
