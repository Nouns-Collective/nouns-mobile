//
//  ENSFetchDomainTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import XCTest
import Combine
@testable import Services

final class ENSFetchDomainTests: XCTestCase {
    
    fileprivate static let token = "0x0000044a32f0964f4bf8fb4d017e230ad33595c0e149b6b2d0c34b733dcf906a"
    
    func testENSFetchDomain() throws {
        
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
        
        var cancellables = Set<AnyCancellable>()
        let fetchExpectation = expectation(description: #function)
        
        // when
        ensProvider.domainLookup(token: ENSFetchDomainTests.token)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case let .failure(error):
                    XCTFail("💥 Something went wrong: \(error)")
                }
            } receiveValue: { domain in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNotNil(domain)
                
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
    
    func testENSFetchDomainFailure() {
        
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
        
        var cancellables = Set<AnyCancellable>()
        let fetchExpectation = expectation(description: #function)
        
        // when
        ensProvider.domainLookup(token: ENSFetchDomainTests.token)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(Thread.isMainThread)
                    XCTAssertEqual((error as? URLError)?.code, .badURL)
                    
                    fetchExpectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("💥 result unexpected")
            }
            .store(in: &cancellables)
        
        // then
        wait(for: [fetchExpectation], timeout: 1.0)
    }
}
