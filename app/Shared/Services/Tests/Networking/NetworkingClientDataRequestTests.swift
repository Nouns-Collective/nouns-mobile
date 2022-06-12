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
@testable import Services

final class NetworkingClientDataRequestTests: XCTestCase {
    
    fileprivate static let baseURL = "https://nouns.wtf"
    
    func testNetworkingClientDataRequestSucceed() async throws {
        
        enum MockDataURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                "Valid Response".data(using: .utf8)
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let request = NetworkDataRequest(url: URL(string: Self.baseURL)!)
        
        // when
        let data = try await client.data(for: request)
        
        // then
        XCTAssertEqual("Valid Response", String(data: data, encoding: .utf8))
    }
    
    func testNetworkingClientDataRequestFailedWithBadURL() async {
        
        enum MockErrorURLResponder: MockURLResponder {
            static func respond(to request: URLRequest) throws -> Data? {
                throw URLError(.badURL)
            }
        }
        
        // given
        let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
        let client = URLSessionNetworkClient(urlSession: urlSession)
        let request = NetworkDataRequest(url: URL(string: Self.baseURL)!)
        
        // when
        do {
            _ = try await client.data(for: request)
            XCTFail("💥 result unexpected")
            
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }
}
