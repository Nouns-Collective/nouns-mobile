//
//  NounComposer.swift
//  Services
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation
import UIKit

public extension Bundle {
    public static let NounAssetBundle = Bundle.module
}

/// The Noun's trait.
public struct Trait {
  
  private enum ImageType: String {
    case png
  }
  
  /// `RLE` data compression of the Noun's trait.
  public let rleData: String
  
  /// Asset image of the Noun's trait stored locally.
  internal let assetImage: String
  
  /// Load Noun's trait bundled image.
  public lazy var data: Data? = {
      NSDataAsset(name: assetImage)?.data
  }()
}

/// This provider class allows interacting with local Nouns' placed in disk.
public protocol NounComposer {
  
  /// The color palette used to draw Noun's background.
  var backgroundColors: [String] { get }
  
  /// The color palette used to draw Noun's parts.
  var palette: [String] { get }
  
  /// Array containing all the bodies mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var bodies: [Trait] { get }
  
  /// Array containing all the accessories mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var accessories: [Trait] { get }
  
  /// Array containing all the heads mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var heads: [Trait] { get }
  
  /// Array containing all the glasses mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var glasses: [Trait] { get }
}

public class OfflineNounComposer: NounComposer {
  
  public lazy var backgroundColors: [String] = {
    layer.bgcolors
  }()
  
  public lazy var palette: [String] = {
    layer.partcolors
  }()
  
  public lazy var bodies: [Trait] = {
    layer.parts[0]
  }()
  
  public lazy var accessories: [Trait] = {
    layer.parts[1]
  }()
  
  public lazy var heads: [Trait] = {
    layer.parts[2]
  }()
  
  public lazy var glasses: [Trait] = {
    layer.parts[3]
  }()
  
  /// Decodes offline Noun's traits.
  private struct Layer: Decodable {
    let partcolors: [String]
    let bgcolors: [String]
    let parts: [[Trait]]
  }
  
  private let layer: Layer
  
  public init(encodedLayersURL: URL) throws {
    let data = try Data(contentsOf: encodedLayersURL)
    layer = try JSONDecoder().decode(Layer.self, from: data)
  }
}

extension Trait: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case assetImage = "name"
    case rleData = "data"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rleData = try container.decode(String.self, forKey: .rleData)
    assetImage = try container.decode(String.self, forKey: .assetImage)
  }
}
