//
//  WebSocketTransport.swift
//  Services
//
//  Created by Ziad Tamim on 25.10.21.
//

import Foundation

class WebSocketTransport {
  private let webSocketTask: URLSessionWebSocketTask
  
  init(task: URLSessionWebSocketTask) {
    self.webSocketTask = task
  }
  
  func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
    webSocketTask.receive { [weak self] result in
      guard let self = self else { return }
      
      completionHandler(result)
      self.receive(completionHandler: completionHandler)
    }
  }
  
}
