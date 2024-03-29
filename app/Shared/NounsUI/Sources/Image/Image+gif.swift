// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

/// Renders an Image object using a `gif` file.
public struct GIFImage: UIViewRepresentable {
    private let named: String
    private let bundle: Bundle
    
    /// Creates and returns an animated image from a given name `gif` file.
    /// - Parameters:
    ///   - named: The name of the gif file.
    ///   - bundle: A representation of the resources stored in a bundle directory on disk.
    public init(_ named: String, bundle: Bundle = Bundle.main) {
        self.named = named
        self.bundle = bundle
    }
    
    public func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.gifImage(named: named, bundle: bundle)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    public func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = UIImage.gifImage(named: named, bundle: bundle)
    }
}

extension UIImage {
    
    /// Creates and returns an animated image from a given name `gif` file.
    /// - Parameters:
    ///   - named: The name of the gif file.
    ///   - bundle: A representation of the resources stored in a bundle directory on disk.
    /// - Returns: The image object that best matches the desired traits with the given name, or nil if no `gif` file was found.
    public class func gifImage(named: String, bundle: Bundle) -> UIImage? {
        guard
            let data = NSDataAsset(name: named, bundle: bundle)?.data,
            let (frames, duration) = GIF(data: data).read()
        else {
            return nil
        }
        
        return UIImage.animatedImage(
            with: frames,
            duration: duration
        )
    }
}

/// Reads `gif` frames from data.
internal class GIF {
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    internal func read() -> (frame: [UIImage], duration: Double)? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        let delays = (0..<count).map {
            // store in ms and truncate to compute GCD more easily
            Int(delayForImage(at: $0, source: source) * 1000)
        }
        let duration = delays.reduce(0, +)
        let gcd = delays.reduce(0, gcd)
        
        var frames = [UIImage]()
        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                return nil
            }
            let frame = UIImage(cgImage: cgImage)
            let frameCount = delays[i] / gcd
            frames.append(contentsOf: Array(repeating: frame, count: frameCount))
        }
        
        return (frames, Double(duration) / 1000.0)
    }
    
    private static let defaultDelay = 1.0
    
    private func delayForImage(at index: Int, source: CGImageSource) -> Double {
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return Self.defaultDelay
        }
        
        let gifProperties = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayWrapper = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self
        )
        
        if delayWrapper.doubleValue == 0 {
            delayWrapper = unsafeBitCast(
                CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                to: AnyObject.self
            )
        }
        
        if let delay = delayWrapper as? Double, delay > 0 {
            return delay
        }
        
        return Self.defaultDelay
    }
    
    private func gcd(_ a: Int, _ b: Int) -> Int {
        let absB = abs(b)
        let r = abs(a) % absB
        if r != 0 {
            return gcd(absB, r)
        }
        return absB
    }
}
