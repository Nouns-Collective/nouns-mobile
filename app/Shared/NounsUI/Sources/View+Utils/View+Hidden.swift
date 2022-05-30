//
//  View+Hidden.swift
//  
//
//  Created by Ziad Tamim on 03.02.22.
//

import SwiftUI

extension View {
  
  @ViewBuilder
  public func hidden(_ condition: Bool) -> some View {
    if condition {
      hidden()
    } else {
      self
    }
  }
}
