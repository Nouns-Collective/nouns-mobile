//
//  Store.swift
//  Nouns
//
//  Created by Ziad Tamim on 03.11.21.
//

import Foundation
import Combine

typealias AppStore = Store<AppState>

class Store<State>: ObservableObject {
  @Published private(set) var state: State
  
  private let reducer: Reducer<State>
  private let middlewares: [Middleware<State>]
  private let queue = DispatchQueue(label: "wtf.nouns.ios.store", qos: .userInitiated)
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(
    initialState state: State,
    reducer: @escaping Reducer<State>,
    middlewares: [Middleware<State>] = []
  ) {
    self.state = state
    self.reducer = reducer
    self.middlewares = middlewares
  }
  
  func dispatch(_ action: Action) {
    queue.sync {
      self.dispatch(state, action)
    }
  }
  
  private func dispatch(_ state: State, _ action: Action) {
    self.state = reducer(state, action)

    middlewares.forEach { middleware in
      let publisher = middleware(state, action)
      
      publisher
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: dispatch)
        .store(in: &cancellables)
    }
  }
}
