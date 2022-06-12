// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
