//
//  String++.swift
//  
//
//  Created by Ziad Tamim on 17.02.22.
//

import Foundation

extension String {
  
  func delete(_ fileExtension: String) -> Self {
    replacingOccurrences(of: "." + fileExtension, with: "")
  }
}
