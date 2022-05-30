//
//  PageIndicator.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-05.
//

import SwiftUI

public struct PageIndicator<SelectionValue>: View where SelectionValue: Hashable {
  public let pages: [SelectionValue]
  public let selection: SelectionValue
  
  public init(pages: [SelectionValue], selection: SelectionValue) {
    self.pages = pages
    self.selection = selection
  }
  
  public var body: some View {
    HStack {
      ForEach(pages, id: \.hashValue) { value in
        Circle()
          .frame(width: 8, height: 8, alignment: .center)
          .foregroundColor(Color.componentNounsBlack)
          .opacity(value == selection ? 1 : 0.1)
      }
    }
  }
}
