//
//  NetworkRequest.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

protocol NetworkRequest {
  var url: URL { get }
}

struct NetworkDataRequest: NetworkRequest {
  var url: URL
  var httpMethod: HTTPMethod
  var httpBody: Data?
  
  init(url: URL, httpMethod: HTTPMethod = .get, httpBody: Data? = nil) {
    self.url = url
    self.httpMethod = httpMethod
    self.httpBody = httpBody
  }
}

extension URLRequest {
  
  init(for request: NetworkRequest) {
    var urlRequest = URLRequest(url: request.url)
    if let dataRequest = request as? NetworkDataRequest {
      if case .post(let contentType) = dataRequest.httpMethod, contentType == .json {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
      urlRequest.httpMethod = dataRequest.httpMethod.description
      urlRequest.httpBody = dataRequest.httpBody
    }
    
    self = urlRequest
  }
}
