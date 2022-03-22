//
//  Bundle+Files.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-03-21.
//

import Foundation

extension Bundle {

  static func files(fromBundle bundle: String) -> [String] {
    let fileManager = FileManager.default
    let bundleURL = Bundle.main.bundleURL
    let assetURL = bundleURL.appendingPathComponent("\(bundle).bundle")

    var items: [String] = []

    do {
      guard let contents = try? fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles) else {
        return []
      }

      for item in contents {
        items.append(item.lastPathComponent)
      }
    }

    print("Items: \(items)")
    return items
  }
}
