//
//  NetworkClient.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation
import Combine

public enum NetworkError: Error {
  /// The response is empty
  case emptyResponse
  
  /// The response has a non-successful status code
  case responseError(statusCode: Int)
  
  /// Any other error, potentially unrelated to the URLSession, was received
  case error(error: Error)
}

public protocol NetworkingClient: AnyObject {
  func data(for request: NetworkRequest) -> AnyPublisher<Data, NetworkError>
}

public class URLSessionNetworkClient: NetworkingClient {
  private var urlSession: URLSession
  
  public init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  public func data(for request: NetworkRequest) -> AnyPublisher<Data, NetworkError> {
    urlSession.dataTaskPublisher(for: URLRequest(for: request))
      .tryMap() { try self.processResponse(from: $0) }
      .mapError { $0 as? NetworkError ?? NetworkError.error(error: $0) }
      .eraseToAnyPublisher()
  }
  
  internal func processResponse(from element: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard let httpResponse = element.response as? HTTPURLResponse else {
      throw NetworkError.emptyResponse
    }
    
    guard httpResponse.statusCode == 200 else {
      throw NetworkError.responseError(statusCode: httpResponse.statusCode)
    }
    
    return element.data
  }
}
