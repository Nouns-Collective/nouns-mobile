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
