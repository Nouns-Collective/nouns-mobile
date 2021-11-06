//
//  Store.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.11.21.
//

import Foundation
import Combine

/// <#Description#>
typealias Reducer<State, Action> = (inout State, Action) -> Void

/// <#Description#>
typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

/// <#Description#>
typealias AppStore = Store<AppState, AppAction>

/// <#Description#>
class Store<State, Action>: ObservableObject {
  
  /// <#Description#>
  @Published private(set) var state: State
  
  private let reducer: Reducer<State, Action>
  private let middlewares: [Middleware<State, Action>]
  private let queue = DispatchQueue(label: "wtf.nouns.ios.store", qos: .userInitiated)
  
  private var cancellables: Set<AnyCancellable> = []
  
  /// <#Description#>
  /// - Parameters:
  ///   - initial: <#initial description#>
  ///   - reducer: <#reducer description#>
  ///   - middlewares: <#middlewares description#>
  init(
    initial: State,
    reducer: @escaping Reducer<State, Action>,
    middlewares: [Middleware<State, Action>] = []
  ) {
    self.state = initial
    self.reducer = reducer
    self.middlewares = middlewares
  }
  
  /// <#Description#>
  /// - Parameter action: <#action description#>
  func dispatch(_ action: Action) {
    queue.sync {
      self.dispatch(&state, action)
    }
  }
  
  private func dispatch(_ state: inout State, _ action: Action) {
    reducer(&state, action)

    middlewares.forEach { middleware in
      let publisher = middleware(state, action)
      publisher
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: dispatch)
        .store(in: &cancellables)
    }
  }
}
