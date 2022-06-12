// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

enum GraphQLOperationType: String, CodingKey {
  
  /// Sstandard HTTP methods.
  case query
  
  /// Realtime operation based on websockets.
  case subscription
}

protocol GraphQLOperation: Encodable {
  
  /// Define the operation entry-points for the API.
  var operationType: GraphQLOperationType { get }
  
  /// The raw GraphQL definition of this operation.
  var operationDefinition: String { get }
  
  ///
  var url: URL? { get }
}

protocol GraphQLQuery: GraphQLOperation {}
extension GraphQLQuery {
  var operationType: GraphQLOperationType { .query }
}

protocol GraphQLSubscription: GraphQLOperation {}
extension GraphQLSubscription {
  var operationType: GraphQLOperationType { .subscription }
}

extension GraphQLOperation {
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: GraphQLOperationType.self)
    try container.encode(operationDefinition, forKey: operationType)
  }
  
  public func encode() throws -> Data {
    try JSONEncoder().encode(self)
  }
}

protocol GraphQLPaginatingQuery: GraphQLQuery {
  var limit: Int { get set }
  var skip: Int { get set }
}
