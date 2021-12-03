//
//  Auction+Adapter.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

extension EtherFormatter {
  
  static func eth(from wei: String) -> String? {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: wei)
  }
}
