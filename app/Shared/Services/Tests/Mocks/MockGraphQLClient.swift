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
import Combine
@testable import Services

class MockGraphQLClient: GraphQL {
  
  func fetch<Query, T>(
    _ query: Query,
    cachePolicy: CachePolicy
  ) async throws -> T where Query: GraphQLQuery, T: Decodable {
    fatalError("Implementation for \(#function) missing")
  }
  
  func subscription<Subscription, T>(_ subscription: Subscription) -> AsyncThrowingStream<T, Error> where Subscription: GraphQLSubscription, T: Decodable {
    fatalError("Implementation for \(#function) missing")
  }
}
