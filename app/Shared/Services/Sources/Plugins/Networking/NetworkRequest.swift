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
