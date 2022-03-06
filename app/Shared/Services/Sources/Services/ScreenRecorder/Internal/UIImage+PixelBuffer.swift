//
//  UIImage+PixelBuffer.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-27.
//

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
    
    var pixelBuffer: CVPixelBuffer? = nil
    let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                     Int(frameSize.width),
                                     Int(frameSize.height),
                                     kCVPixelFormatType_32BGRA,
                                     nil,
                                     &pixelBuffer)
    
    if status != kCVReturnSuccess {
      return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
    let context = CGContext(data: data,
                            width: Int(frameSize.width),
                            height: Int(frameSize.height),
                            bitsPerComponent: 8,
                            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                            space: rgbColorSpace,
                            bitmapInfo: bitmapInfo.rawValue)
    
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    return pixelBuffer
  }
}
