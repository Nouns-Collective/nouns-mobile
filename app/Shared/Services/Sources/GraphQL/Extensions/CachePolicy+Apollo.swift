//
//  CachePolicy+Apollo.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

extension CachePolicy {
  func policy() -> Apollo.CachePolicy {
    switch self {
    case .returnCacheDataElseFetch:
      return .returnCacheDataElseFetch
    case .fetchIgnoringCacheData:
      return .fetchIgnoringCacheData
    case .fetchIgnoringCacheCompletely:
      return .fetchIgnoringCacheCompletely
    case .returnCacheDataDontFetch:
      return .returnCacheDataDontFetch
    case .returnCacheDataAndFetch:
      return .returnCacheDataAndFetch
    }
  }
}
