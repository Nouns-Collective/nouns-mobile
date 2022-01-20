//
//  PageProvider.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-20.
//

import Foundation

/// A service to run queries, construct a `Page` of the desired return type, as well the `cursor` and `hasNext` properties
public class PageProvider {
  
  enum PageProviderError: Error {
    
    /// An error presented when the graphQLClient is `nil`
    case missingClient
  }
  
  private weak var graphQLClient: GraphQL?
  
  public init(graphQLClient: GraphQL) {
    self.graphQLClient = graphQLClient
  }
  
  /// Fetches a page from the GraphQL endpoint and queries the next (1) item to see if it exists
  /// Based on this information, we can infer a `hasNext` value on the original `Page` struct
  ///
  /// This implemention was built as noun subgraph queries do not return `cursor`
  /// or `hasNext` information, as some GraphQL endpoints do
  public func page<Query, T>(_ returnType: T.Type, _ query: Query, cachePolicy: CachePolicy) async throws -> Page<[T]> where Query: GraphQLPaginatingQuery, T: Decodable {
    
    guard let graphQLClient = graphQLClient else {
      throw PageProviderError.missingClient
    }

    // Query intended page
    var page: Page<[T]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    page.cursor = page.data.count + query.skip
    
    // Query next page (just one item is necessary) to see if it has more data
    var nextPageQuery = query
    nextPageQuery.skip = page.cursor
    nextPageQuery.limit = 1
    
    let nextPage: Page<[T]> = try await graphQLClient.fetch(
      nextPageQuery,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    // Set `hasNext` of previous page based on contents of next page
    page.hasNext = !nextPage.data.isEmpty
    
    return page
  }
}

