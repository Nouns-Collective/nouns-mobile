//
//  Auction+Adapter.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

extension Auction {
  
  var ethAmount: String? {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: amount)
  }
}

extension Bid {
  
  var ethAmount: String? {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: amount)
  }
}
