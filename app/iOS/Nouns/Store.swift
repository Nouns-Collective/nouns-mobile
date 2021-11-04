//
//  Store.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.11.21.
//

import Foundation
import Combine

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
      self.dispatch(self.state, action)
    }
  }
  
  private func dispatch(_ currentState: State, _ action: Action) {
    let newState = reducer(currentState, action)

    middlewares.forEach { middleware in
      let publisher = middleware(newState, action)
      publisher
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: dispatch)
        .store(in: &cancellables)
    }

    state = newState
  }
}
