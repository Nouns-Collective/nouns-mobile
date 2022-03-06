//
//  MockURLProtocol.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 26.10.21.
//

import Foundation
import XCTest

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data?
}

class MockHTTPURLProtocol<Responder: MockURLResponder>: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let client = client else { return }
        defer { client.urlProtocolDidFinishLoading(self) }
        
        do {
            guard let data = try Responder.respond(to: request) else {
                return client.urlProtocol(self,
                                          didReceive: URLResponse(),
                                          cacheStoragePolicy: .notAllowed)
                
            }
            
            let response = try XCTUnwrap(
                HTTPURLResponse(url: XCTUnwrap(request.url),
                                statusCode: 200,
                                httpVersion: "HTTP/1.1",
                                headerFields: nil))
            
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
    
}

extension URLSession {
    
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockHTTPURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockHTTPURLProtocol<T>.self)
    }
}
