//
//  NounActivities.swift
//  Nouns
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation
import Services

struct ActivityState {
  var votes: [Vote] = []
  var isLoading = false
  var error: Error?
}
