//
//  NounComposer.swift
//  Services
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation

/// Temporary bridging of the module bundle so that the app layer can compose static noun views
/// Should be removed once persistence & network fetching is implemented
public extension Bundle {
    static let NounAssetBundle = Bundle.module
}

/// The Noun's trait.
public struct Trait {
    
    /// `RLE` data compression of the Noun's trait.
    public let rleData: String
    
    /// Asset image of the Noun's trait stored locally.
    public let assetImage: String
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

/// A Flavour of the NounComposer to load local Nouns' trait.
public class OfflineNounComposer: NounComposer {
    
    /// The background list of colors.
    public lazy var backgroundColors = layer.bgcolors
    
    /// The color palette used to draw `Nouns` with `RLE` data.
    public lazy var palette = layer.partcolors
    
    /// The body list of traits.
    public lazy var bodies = layer.parts[0]
    
    /// The accessory list of traits.
    public lazy var accessories = layer.parts[1]
    
    /// The head list of traits.
    public lazy var heads = layer.parts[2]
    
    /// The glasses list of traits.
    public lazy var glasses = layer.parts[3]
    
    /// Decodes offline Noun's traits.
    private struct Layer: Decodable {
        let partcolors: [String]
        let bgcolors: [String]
        let parts: [[Trait]]
    }
    
    private let layer: Layer
    
    internal init(encodedLayersURL: URL) throws {
        let data = try Data(contentsOf: encodedLayersURL)
        layer = try JSONDecoder().decode(Layer.self, from: data)
    }
    
    /// Creates and returns an `NounComposer` object from an existing set of Nouns' traits.
    /// - Returns: A new NounComposer object.
    public static func `default`() throws -> NounComposer {
        guard let url = Bundle.module.url(forResource: "encoded-layers", withExtension: "json")
        else {
            throw URLError(.badURL)
        }
        
        return try OfflineNounComposer(encodedLayersURL: url)
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
