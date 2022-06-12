// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

import UIKit

internal extension UIImage {
  
  /// Convert `UIImage` to `CVPixelBuffer`.
  ///
  /// This method copies source `UIImage` data to a `CVPixelBuffer`.
  ///
  /// - Returns: `CVPixelBuffer` or `nil`, if unable to convert data
  func toPixelBuffer() -> CVPixelBuffer? {
    guard let cgImage = self.cgImage else { return nil }
    
    let frameSize = CGSize(width: cgImage.width,
                           height: cgImage.height)
    
    var pixelBuffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                     Int(frameSize.width),
                                     Int(frameSize.height),
                                     kCVPixelFormatType_32BGRA,
                                     nil,
                                     &pixelBuffer)
    
    if status != kCVReturnSuccess {
      return nil
    }
    
    guard let pixelBuffer = pixelBuffer else {
      return nil
    }

    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    let data = CVPixelBufferGetBaseAddress(pixelBuffer)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
    let context = CGContext(data: data,
                            width: Int(frameSize.width),
                            height: Int(frameSize.height),
                            bitsPerComponent: 8,
                            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                            space: rgbColorSpace,
                            bitmapInfo: bitmapInfo.rawValue)
    
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    return pixelBuffer
  }
}
