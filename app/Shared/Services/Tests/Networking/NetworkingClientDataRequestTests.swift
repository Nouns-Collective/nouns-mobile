//
//  NetworkingClientDataRequestTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 26.10.21.
//

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
