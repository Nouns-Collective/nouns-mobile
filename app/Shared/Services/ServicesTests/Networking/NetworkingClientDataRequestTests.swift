//
//  NetworkingClientDataRequestTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 26.10.21.
//

import XCTest
import Combine
@testable import Services

final class NetworkingClientDataRequestTests: XCTestCase {
  
  func testNetworkingClientDataRequestSucceed() throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data {
        "Valid Response".data(using: .utf8)!
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let request = NetworkDataRequest(
      url: URL(string: "https://nouns.wtf")!,
      httpBody: Data()
    )
    
    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)
    
    // when
    client.data(for: request)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let error):
          XCTFail("🔥 Oops failed: \(error)")
        }
      } receiveValue: { data in
        XCTAssertEqual("Valid Response", String(data: data, encoding: .utf8))
      }
      .store(in: &cancellables)
    
    // then
    wait(for: [expectation], timeout: 1.0)
  }
  
  func testNetworkingClientDataRequestFailedWithBadURL() {
    
    enum MockErrorURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data {
        throw URLError(.badURL)
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let request = NetworkDataRequest(
      url: URL(string: "https://nouns.wtf")!,
      httpBody: Data()
    )
    
    var cancellables = Set<AnyCancellable>()
    let expectation = expectation(description: #function)
    
    // when
    client.data(for: request)
      .sink { completion in
        if case let .failure(.request(error)) = completion{
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
