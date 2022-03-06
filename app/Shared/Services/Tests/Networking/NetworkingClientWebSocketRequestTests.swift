//
//  NetworkingClientWebSocketRequestTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 26.10.21.
//

import XCTest
import Combine
@testable import Services

final class NetworkingClientWebSocketRequestTests: XCTestCase {
  
  fileprivate static let baseURL = "wss://nouns.wtf"
  
  func testNetworkingClientWebSocketRequestSucceed() throws {
      
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        "Valid Response".data(using: .utf8)!
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let request = NetworkDataRequest(url: URL(string: Self.baseURL)!)
    
    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)
    
    // when
    client.receive(for: request)
      .sink { completion in
        XCTFail("🔥 Oops shouldn't complete: \(completion)")
        
      } receiveValue: { data in
        XCTAssertEqual("Valid Response", String(data: data, encoding: .utf8))
        
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testNetworkingClientWebSocketRequestFailedWithBadURL() throws {
      
    enum MockErrorURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        throw URLError(.badURL)
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let request = NetworkDataRequest(url: URL(string: Self.baseURL)!)
    
    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)
    
    // when
    client.receive(for: request)
      .sink { completion in
        if case let .failure(error) = completion {
          XCTAssertEqual((error as? URLError)?.code, .badURL)
          
          expectation.fulfill()
        }
      } receiveValue: { _ in
        XCTFail("💥 result unexpected")
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [expectation], timeout: 1.0)
  }
}
