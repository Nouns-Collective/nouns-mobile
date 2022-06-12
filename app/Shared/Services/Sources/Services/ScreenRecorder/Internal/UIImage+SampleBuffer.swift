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
import AVFoundation

internal extension UIImage {
  
  private static let sampleBufferTimescale: Int32 = 600
  
  private func getTimingInfo(frameIndex: Int, framesPerSecond: Double) -> CMSampleTimingInfo {
    let frameDuration: Int = Int(Double(UIImage.sampleBufferTimescale) / framesPerSecond)
    
    var timingInfo = CMSampleTimingInfo()
    timingInfo.presentationTimeStamp = CMTimeMake(value: Int64(frameDuration * frameIndex),
                                                  timescale: UIImage.sampleBufferTimescale)
    timingInfo.duration = CMTimeMake(value: Int64(frameDuration),
                                     timescale: UIImage.sampleBufferTimescale)
    timingInfo.decodeTimeStamp = CMTime.invalid
    
    return timingInfo
  }
  
  /// Convert `UIImage` to `CMSampleBuffer` and set corresponding sample timing info.
  ///
  /// `CMSampleBuffer` wraps `CVPixelBuffer` data and adds sample timing info relative to other samples in a set.
  ///
  /// With provided `frameIndex` and `framesPerSecond` the following timing rules apply:
  /// Sample duration (seconds): `1 / framesPerSecond`
  /// Sample start time: `frameIndex / framesPerSecond`
  ///
  /// - Parameters:
  ///   - frameIndex: index of the frame along other frames in a sample set. By default is 0.
  ///   - framesPerSecond: FPS rate of a sample set. By default is 24.
  ///
  /// - Returns: `CMSampleBuffer` with calculated timing info or `nil`, if unable to convert
  func toSampleBuffer(frameIndex: Int = 0, framesPerSecond: Double = 60) -> CMSampleBuffer? {
    guard frameIndex >= 0 && framesPerSecond > 0 else { return nil }
    
    guard let pixelBuffer = self.toPixelBuffer() else { return nil }
    
    var formatDesc: CMFormatDescription?
    CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                 imageBuffer: pixelBuffer,
                                                 formatDescriptionOut: &formatDesc)
    
    var timingInfo = getTimingInfo(frameIndex: frameIndex, framesPerSecond: framesPerSecond)
    var sampleBuffer: CMSampleBuffer?
    CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                             imageBuffer: pixelBuffer,
                                             formatDescription: formatDesc!,
                                             sampleTiming: &timingInfo,
                                             sampleBufferOut: &sampleBuffer)
    
    return sampleBuffer
  }
  
}
