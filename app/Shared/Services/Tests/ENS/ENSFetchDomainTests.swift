//
//  ENSFetchDomainTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
@testable import Services

final class ENSFetchDomainTests: XCTestCase {
  
  fileprivate static let token = "0x0000044a32f0964f4bf8fb4d017e230ad33595c0e149b6b2d0c34b733dcf906a"
  
  func testENSFetchDomain() async throws {
    
    enum MockDataURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        Fixtures.data(contentOf: "ens-domain-response-valid", withExtension: "json")
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockDataURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let ensProvider = TheGraphENSProvider(graphQLClient: graphQLClient)
    
    // when
    let domain = try await ensProvider.domainLookup(token: ENSFetchDomainTests.token)
    
    // then
    XCTAssertNotNil(domain)
  }
  
  func testENSFetchDomainFailure() async {
    
    enum MockErrorURLResponder: MockURLResponder {
      static func respond(to request: URLRequest) throws -> Data? {
        throw URLError(.badURL)
      }
    }
    
    // given
    let urlSession = URLSession(mockResponder: MockErrorURLResponder.self)
    let client = URLSessionNetworkClient(urlSession: urlSession)
    let graphQLClient = GraphQLClient(networkingClient: client)
    let ensProvider = TheGraphENSProvider(graphQLClient: graphQLClient)
    
    do {
      _ = try await ensProvider.domainLookup(token: ENSFetchDomainTests.token)
      
      // when
      XCTFail("💥 result unexpected")
    } catch {
      
      // when
      XCTAssertEqual((error as? URLError)?.code, .badURL)
    }
  }
  
  
}
