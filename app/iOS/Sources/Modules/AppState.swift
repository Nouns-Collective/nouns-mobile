//
//  AppState.swift
//  Nouns
//
//  Created by Ziad Tamim on 10.11.21.
//

import Foundation

protocol Action { }

typealias Reducer<State> = (State, Action) -> State

func appReducer(state: AppState, action: Action) -> AppState {
  AppState(
    onChainNouns: onChainNounsReducer(state: state.onChainNouns, action: action),
    liveAuction: liveAuctionReducer(state: state.liveAuction, action: action),
    activities: onChainNounActivitiesReducer(state: state.activities, action: action)
  )
}

struct AppState {
  var onChainNouns = OnChainNouns()
  var liveAuction = LiveAuction()
  var activities = OnChainNounActivities()
}
