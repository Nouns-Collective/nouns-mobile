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
  
  /// Unknown error
  case unknown
}

public protocol NetworkingClient: AnyObject {
  
  /// Returns a publisher that wraps a URL data task for a given URL request.
  ///
  /// - Parameters:
  ///   - request: The URL request for which to create a task.
  ///
  /// - Returns: The publisher publishes data when the task completes, or terminates if the task fails with an error.
  func data(for request: NetworkRequest) async throws -> Data
  
  /// Reads a `WebSocket` message once all the frames of the message are available.
  ///
  /// - Parameters:
  ///   - request: The URL request for which to create a `WebSocket` task.
  ///
  /// - Returns: The publisher publishes data when the task receives updates, or terminates if the task fails with an error.
  func receive(for request: NetworkRequest) -> AnyPublisher<Data, Error>
}

public class URLSessionNetworkClient: NetworkingClient {
  private var urlSession: URLSession
  
  public init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }
  
  public func data(for request: NetworkRequest) async throws -> Data {
    let (data, response) = try await urlSession.data(for: URLRequest(for: request))
    try processResponse(from: response)
    return data
  }
  
  internal func processResponse(from response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw RequestError.noData
    }
    
    switch httpResponse.statusCode {
    case 200:
      break
    default:
      throw RequestError.http(statusCode: httpResponse.statusCode)
    }
  }
  
  public func receive(for request: NetworkRequest) -> AnyPublisher<Data, Error> {
    let subject = PassthroughSubject<Data, Error>()
    let websocketTask = urlSession.webSocketTask(with: URLRequest(for: request))
    let webSocketTransport = WebSocketTransport(task: websocketTask)
    
    webSocketTransport.receive { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let message):
        do {
          let data = try self.processResponse(from: message)
          subject.send(data)
        } catch {
          subject.send(completion: .failure(error))
        }
        
      case .failure(let error):
        subject.send(completion: .failure(error))
      }
    }
    
    return subject
      .handleEvents(receiveSubscription: { _ in
        websocketTask.resume()
      }, receiveCancel: {
        websocketTask.cancel()
      })
      .eraseToAnyPublisher()
  }
  
  internal func processResponse(from message: URLSessionWebSocketTask.Message) throws -> Data {
    switch message {
    case .data(let data):
      return data
      
    case .string(let string):
      guard let data = string.data(using: .utf8) else {
        throw RequestError.noData
      }
      return data
      
    @unknown default:
      throw RequestError.unknown
    }
  }
}
