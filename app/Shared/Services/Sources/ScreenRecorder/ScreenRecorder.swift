//
//  ScreenRecorder.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-27.
//

import UIKit
import SwiftUI
import AVFoundation
import Combine

public protocol ScreenRecorder: AnyObject {
  
  /// Starts recording a SwiftUI view
  ///
  /// - Parameters:
  ///    - view: A SwiftUI view to start recording
  func startRecording<ContentView: View>(_ view: ContentView)
  
  /// Starts recording a UIKit view (UIView)
  ///
  /// - Parameters:
  ///    - view: A UIView to start recording
  func startRecording(_ view: UIView)
  
  /// Stops recording the view
  ///
  /// - Returns: A file URL where the video file was temporarily saved
  func stopRecording() async throws -> URL
}

public enum ScreenRecorderError: Error {
  
  /// No frames were collected from the view
  case noFrames
  
  /// The FPS is a negative amount
  case invalidFPS
  
  /// A fatal error has occured
  case failure(error: Error)
  
  /// Another error has occured
  case internalError
}

public class CAScreenRecorder: ScreenRecorder {
  
  /// A reference to all the recorded frames of the recorded view
  private var frames = [UIImage]()
  
  /// Link to the display refresh rate to monitor and save each frame
  private var displayLink: CADisplayLink?
  
  /// Called when we're done writing the video
  private var completion: ((URL?) -> Void)?
  
  /// The view we're actively recording
  private var sourceView: UIView?
  
  /// Target frames per second to record the video at
  private var framesPerSecond: Double
  
  private var frameSize: CGSize {
    CGSize(width: (frames.first?.size.width ?? 0) * UIScreen.main.scale,
           height: (frames.first?.size.height ?? 0) * UIScreen.main.scale)
  }
  
  private func videoSettings(codecType: AVVideoCodecType) -> [String: Any] {
    return [
      AVVideoCodecKey: codecType,
      AVVideoWidthKey: frameSize.width,
      AVVideoHeightKey: frameSize.height
    ]
  }
  
  private var pixelAdaptorAttributes: [String: Any] {
    [
      kCVPixelBufferPixelFormatTypeKey as String: Int(kCMPixelFormat_32BGRA)
    ]
  }
  
  public init(framesPerSecond: Double = 60) {
    self.framesPerSecond = framesPerSecond
  }
  
  public func startRecording<ContentView>(_ view: ContentView) where ContentView: View {
    guard let uiView = viewToUIView(view) else { return }
    startRecording(uiView)
  }
  
  public func startRecording(_ view: UIView) {
    self.sourceView = view
    displayLink = CADisplayLink(target: self, selector: #selector(tick))
    displayLink?.add(to: RunLoop.main, forMode: .common)
  }
  
  public func stopRecording() async throws -> URL {
    displayLink?.invalidate()
    displayLink = nil
    
    // Remove first frame, which is often a grey transisionary frame as the view gets added
    _ = frames.popLast()
    
    do {
      let videoURL = try await writeToVideo(fps: 60)
      return videoURL
    } catch {
      throw error
    }
  }
  
  /// A method called every screen refresh to capture current visual state of the view
  @objc
  private func tick(_ displayLink: CADisplayLink) {
    guard let sourceView = sourceView else { return }

    let renderer = UIGraphicsImageRenderer(size: sourceView.intrinsicContentSize)

    let frame = renderer.image(actions: { _ in
      sourceView.drawHierarchy(in: CGRect(origin: .zero, size: sourceView.intrinsicContentSize), afterScreenUpdates: true)
    })
    
    frames.append(frame)
  }
  
  /// Accumulates all frames and transforms them into an exportable video
  private func writeToVideo(fps: Double, codecType: AVVideoCodecType = .h264) async throws -> URL {
    
    guard self.frames.count > 0 else {
      throw ScreenRecorderError.noFrames
    }
    
    guard fps > 0 else {
      throw ScreenRecorderError.invalidFPS
    }
    
    let url = self.generateUniqueFileURL()
    
    let writer: AVAssetWriter
    do {
      writer = try AVAssetWriter(outputURL: url, fileType: .mov)
    } catch {
      throw ScreenRecorderError.failure(error: error)
    }
    
    let input = AVAssetWriterInput(mediaType: .video,
                                   outputSettings: self.videoSettings(codecType: codecType))
    
    if writer.canAdd(input) {
      writer.add(input)
    } else {
      throw ScreenRecorderError.internalError
    }
    
    let pixelAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
                                                            sourcePixelBufferAttributes: self.pixelAdaptorAttributes)
    
    writer.startWriting()
    writer.startSession(atSourceTime: CMTime.zero)
    
    var frameIndex: Int = 0
    while frameIndex < self.frames.count {
      if input.isReadyForMoreMediaData {
        if let buffer = self.frames[frameIndex].toSampleBuffer(frameIndex: frameIndex,
                                                               framesPerSecond: fps) {
          pixelAdaptor.append(CMSampleBufferGetImageBuffer(buffer)!,
                              withPresentationTime: CMSampleBufferGetOutputPresentationTimeStamp(buffer))
        }
        
        frameIndex += 1
      }
    }
    
    await writer.finishWriting()
    
    switch writer.status {
    case .completed:
      print("Successfully finished writing video \(url)")
      return url
    default:
      let error = writer.error ?? ScreenRecorderError.internalError
      print("Finished writing video without success \(error)")
      throw error
    }
  }
  
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("mov")
    return fileURL
  }
  
  /// Converts a SwiftUI view to a UIView in order to record
  private func viewToUIView<ContentView: View>(_ view: ContentView) -> UIView? {
    let controller = UIHostingController(rootView: view)
    let view = controller.view
    
    let targetSize = controller.view.intrinsicContentSize
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .white
    
    return view
  }
}
