//
//  MockApolloClient.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-21.
//

import Foundation
import Apollo
import Services

class MockApolloClient: ApolloClientProtocol {
  var store: ApolloStore
  
  var cacheKeyForObject: CacheKeyForObject?
  
  struct MockResult {
    var data: GraphQLSelectionSet?
    var errors: [GraphQLError]?
    var source: MockSource
    
    enum MockSource {
      case server
      case cache
      
      func source<T>() -> GraphQLResult<T>.Source where T: GraphQLSelectionSet {
        switch self {
        case .server:
          return .server
        case .cache:
          return .cache
        }
      }
    }
  }
  
  private var result: MockResult?
  private var error: Error?
  
  init(store: ApolloStore = ApolloStore()) {
    self.store = store
    self.cacheKeyForObject = { $0["id"] }
  }
  
  func set(result: MockResult?, error: Error?) {
    self.result = result
    self.error = error
  }
  
  func reset() {
    result = nil
    error = nil
  }
  
  func clearCache(callbackQueue: DispatchQueue, completion: ((Result<Void, Error>) -> Void)?) {
    // Left intentionally blank
    fatalError("Implementation for \(#function) missing")
  }
  
  func fetch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, contextIdentifier: UUID?, queue: DispatchQueue, resultHandler: GraphQLResultHandler<Query.Data>?) -> Apollo.Cancellable where Query : GraphQLQuery {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      if let result = self.result  {
        if let data = result.data, let responseData = try? Query.Data(data) {
          resultHandler?(.success(GraphQLResult(data: responseData, extensions: nil, errors: result.errors, source: result.source.source(), dependentKeys: nil)))
        } else {
          resultHandler?(.success(GraphQLResult(data: nil, extensions: nil, errors: result.errors, source: result.source.source(), dependentKeys: nil)))
        }
      } else if let error = self.error {
        resultHandler?(.failure(error))
      }
    })
    return EmptyCancellable()
  }
  
  func watch<Query>(query: Query, cachePolicy: Apollo.CachePolicy, callbackQueue: DispatchQueue, resultHandler: @escaping GraphQLResultHandler<Query.Data>) -> GraphQLQueryWatcher<Query> where Query : GraphQLQuery {
    // Left intentionally blank
    fatalError("Implementation for \(#function) missing")
  }
  
  func perform<Mutation>(mutation: Mutation, publishResultToStore: Bool, queue: DispatchQueue, resultHandler: GraphQLResultHandler<Mutation.Data>?) -> Apollo.Cancellable where Mutation : GraphQLMutation {
    // Left intentionally blank
    fatalError("Implementation for \(#function) missing")
  }
  
  func upload<Operation>(operation: Operation, files: [GraphQLFile], queue: DispatchQueue, resultHandler: GraphQLResultHandler<Operation.Data>?) -> Apollo.Cancellable where Operation : GraphQLOperation {
    // Left intentionally blank
    fatalError("Implementation for \(#function) missing")
  }
  
  func subscribe<Subscription>(subscription: Subscription, queue: DispatchQueue, resultHandler: @escaping GraphQLResultHandler<Subscription.Data>) -> Apollo.Cancellable where Subscription : GraphQLSubscription {
    // Left intentionally blank
    fatalError("Implementation for \(#function) missing")
  }
}
