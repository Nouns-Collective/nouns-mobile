// Copyright (C) 2022  Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Originally authored by Ziad Tamim
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/// This script is to be used to generate a json file describing all the traits and it's additional textures for animation purposes,
/// such a set of eye blinking frames to match a set of glasses or animated mouth frames to match a noun head.
import Foundation
import TabularData
import ArgumentParser

/// Decodes offline Noun's traits.
struct Layer: Codable {
  let palette: [String]
  let bgcolors: [String]
  let images: [String: [Trait]]
}

/// The Noun's trait.
struct Trait: Codable {
  
  /// `RLE` data compression of the Noun's trait.
  let data: String
  
  /// Asset image of the Noun's trait stored locally.
  let filename: String
  
  /// Various animations for the related trait.
  let textures: [String: [String]]
  
  private enum CodingKeys: String, CodingKey {
    case data
    case filename
    case textures
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decode(String.self, forKey: .data)
    filename = try container.decode(String.self, forKey: .filename)
    
    guard let allTextures = decoder.userInfo[.textures] as? [String: [String: [String]]], let traitTextures = allTextures[filename] else {
      textures = [:]
      return
    }
    
    textures = traitTextures
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(filename, forKey: .filename)
    try container.encode(data, forKey: .data)
    try container.encode(textures, forKey: .textures)
  }
}

public struct NounsTextureGenerator: ParsableCommand {
  
//  @Option var inputFile: String
  
  public init() { }
  
  public func run() throws {
    let inputFileURL = URL(fileURLWithPath: "custom-heads-and-mouths.csv")
    let layerDataFrame = try loadCSV(at: inputFileURL)
    
    // Convert the loaded CSV file to json.
    var textures = [String: [String: [String]]]()
    
    // Iterate through the CSV data & build the head to mouth structure.
    let fileExtension = "png"
    
    // Head -> mouth
    for row in layerDataFrame.rows {
      guard let head = row["head", String.self]?.delete(fileExtension),
            let mouth1 = row["mouth-1", String.self]?.delete(fileExtension),
            let mouth2 = row["mouth-2", String.self]?.delete(fileExtension),
            let mouth3 = row["mouth-3", String.self]?.delete(fileExtension),
            let mouth4 = row["mouth-4", String.self]?.delete(fileExtension)
      else { continue }

      if textures[head] == nil {
        textures[head] = ["mouth": [mouth1, mouth2, mouth3, mouth4]]
      } else {
        textures[head]?["mouth"] = [mouth1, mouth2, mouth3, mouth4]
      }
    }
    
    // Glasses -> glasses-frame + eyes
    
    let glassesURL = URL(fileURLWithPath: "custom-glasses-and-eyes.csv")
    let glassesDataFrame = try loadCSV(at: glassesURL)
    
    for row in glassesDataFrame.rows {
      guard let glasses = row["glasses", String.self]?.delete(fileExtension),
            let glassesFrame = row["glasses-frame", String.self]?.delete(fileExtension),
            let eyesBlink1 = row["eyes-blink-1", String.self]?.delete(fileExtension).replacingOccurrences(of: "-1", with: "_1"),
            let eyesBlink2 = row["eyes-blink-2", String.self]?.delete(fileExtension).replacingOccurrences(of: "-2", with: "_2"),
            let eyesBlink3 = row["eyes-blink-3", String.self]?.delete(fileExtension).replacingOccurrences(of: "-3", with: "_3"),
            let eyesBlink4 = row["eyes-blink-4", String.self]?.delete(fileExtension).replacingOccurrences(of: "-4", with: "_4"),
//            let eyesBlink5 = row["eyes-blink-5", String.self]?.delete(fileExtension),
            let eyesShift1 = row["eyes-shift-1", String.self]?.delete(fileExtension).replacingOccurrences(of: "-1", with: "_1"),
            let eyesShift2 = row["eyes-shift-2", String.self]?.delete(fileExtension).replacingOccurrences(of: "-2", with: "_2"),
            let eyesShift3 = row["eyes-shift-3", String.self]?.delete(fileExtension).replacingOccurrences(of: "-3", with: "_3"),
            let eyesShift4 = row["eyes-shift-4", String.self]?.delete(fileExtension).replacingOccurrences(of: "-4", with: "_4"),
            let eyesShift5 = row["eyes-shift-5", String.self]?.delete(fileExtension).replacingOccurrences(of: "-5", with: "_5"),
            let eyesShift6 = row["eyes-shift-6", String.self]?.delete(fileExtension).replacingOccurrences(of: "-6", with: "_6")
      else { continue }

      if textures[glasses] == nil {
        textures[glasses] = [
          "glasses-frame": [glassesFrame],
          "eyes-blink": [eyesBlink1, eyesBlink2, eyesBlink3, eyesBlink4, eyesBlink1],
          "eyes-shift": [eyesShift1, eyesShift2, eyesShift3, eyesShift4, eyesShift5, eyesShift6]
        ]
      } else {
        textures[glasses]?["glasses-frame"] = [glassesFrame]
        textures[glasses]?["eyes-blink"] = [eyesBlink1, eyesBlink2, eyesBlink3, eyesBlink4]
        textures[glasses]?["eyes-shift"] = [eyesShift1, eyesShift2, eyesShift3, eyesShift4, eyesShift5, eyesShift6]
      }
    }
        
    // Alter the noun layers data to introduce the animation.
    let layers = try loadNounsLayers(userInfo: textures)
    
    var outputFileURL = inputFileURL.deletingLastPathComponent()
    outputFileURL.appendPathComponent("nouns-traits-layers_v2.json")
    
    let decodedData = try JSONEncoder().encode(layers)
    try decodedData.write(to: outputFileURL)
  }
  
  private func loadNounsLayers(userInfo: [String: [String: [String]]]) throws -> Layer {
    let filename = "nouns-traits-layers_v2"
    let fileExtension = "json"
    
    guard let url = Bundle.module.url(
      forResource: filename,
      withExtension: fileExtension
    ) else {
      throw RuntimeError("🛑 File \(filename) not found!")
    }
    
    let jsonDecoder = JSONDecoder()
    jsonDecoder.userInfo = [.textures: userInfo]
    
    let data = try Data(contentsOf: url)
    return try jsonDecoder.decode(Layer.self, from: data)
  }
  
  // MARK: - CSV
  
  private func loadCSV(at url: URL) throws -> DataFrame {
    let readingOptions = CSVReadingOptions(
      hasHeaderRow: true,
      ignoresEmptyLines: true,
      delimiter: ";"
    )
    
    return try DataFrame(
      contentsOfCSVFile: url,
      options: readingOptions
    )
  }
}

extension CodingUserInfoKey {
  
    static let textures = CodingUserInfoKey(rawValue: "textures")!
}
