//
//  Auction+Adapter.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

extension EtherFormatter {
  
  static func eth(from wei: String, minimumFractionDigits: Int = 2) -> String? {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    formatter.minimumFractionDigits = minimumFractionDigits
    return formatter.string(from: wei)
  }
}
