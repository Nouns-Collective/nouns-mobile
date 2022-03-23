//
//  Thumbnail.swift
//  
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI

extension Image {
  
  public func asThumbnail(maxWidth: CGFloat = 20, maxHeight: CGFloat = 20) -> some View {
    resizable()
      .scaledToFit()
      .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
  }
}
