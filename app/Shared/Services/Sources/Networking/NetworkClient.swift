//
//  NetworkClient.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation
import Combine

public enum RequestError: Error {
  /// The response is empty
  case noData
  
  /// The response has a non-successful status code
  case http(statusCode: Int)
  
  /// Any other error, potentially unrelated to the URLSession, was received
  case request(error: Error)
}

public protocol NetworkingClient: AnyObject {
  /// Performs an HTTP request on a server
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - request: The request to perform on the server
  ///
  /// - Returns: A publisher emitting a `Data` type  instance. The publisher will emit on the *main* thread.
  func data(for request: NetworkRequest) -> AnyPublisher<Data, RequestError>
}

public class URLSessionNetworkClient: NetworkingClient {
  private var urlSession: URLSession
  
  public init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  public func data(for request: NetworkRequest) -> AnyPublisher<Data, RequestError> {
    urlSession.dataTaskPublisher(for: URLRequest(for: request))
      .tryMap() { try self.processResponse(from: $0) }
      .mapError { $0 as? RequestError ?? RequestError.request(error: $0) }
      .eraseToAnyPublisher()
  }
  
  internal func processResponse(from element: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard let httpResponse = element.response as? HTTPURLResponse else {
      throw RequestError.noData
    }
    
    switch httpResponse.statusCode {
    case 200:
      return element.data
    default:
      throw RequestError.http(statusCode: httpResponse.statusCode)
    }
  }
}
