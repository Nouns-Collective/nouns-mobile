//
//  ScreenRecorder.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-27.
//

import UIKit
import SwiftUI
import AVFoundation

public protocol ScreenRecorder: AnyObject {
  
  /// Starts recording a SwiftUI view
  ///
  /// - Parameters:
  ///    - view: A SwiftUI view to start recording
  ///    - backgroundView: An optional background view to place behind the main recorded view
  func startRecording<ContentView: View, BackgroundView: View>(_ view: ContentView, backgroundView: BackgroundView?)
  
  /// Starts recording a UIKit view (UIView)
  ///
  /// - Parameters:
  ///    - view: A UIView to start
  ///    - backgroundView: An optional background view to place behind the main recorded view
  func startRecording(_ view: UIView, backgroundView: UIView?)
  
  /// Adds a watermark to the bottom left corner of the recording view
  ///
  /// - Parameters:
  ///   - image: An image to add as a watermark
  func addWatermark(_ image: UIImage)
  
  /// Removes the watermark from the recording view
  func removeWatermark()
  
  /// Stops recording the view
  ///
  /// - Returns: A preview video URL for the video without a watermark and the share video URL for the video with the watermark
  func stopRecording() async throws -> (previewVideoURL: URL, shareVideoURL: URL)
}

public enum ScreenRecorderError: Error {
  
  /// No frames were collected from the view
  case noFrames
  
  /// The FPS is a negative amount
  case invalidFPS
  
  /// Failure to add video input to AVAssetWriter
  case unableToAddVideoInput
  
  /// Failure to create sample buffer from image frame
  case unableToCreateSampleBuffer
  
  /// Failure to append buffer to pixel adaptor
  case unableToAppendBuffer
  
  /// A fatal error has occured
  case failure(error: Error)
  
  /// Another error has occured
  case internalError
}

public class CAScreenRecorder: ScreenRecorder {
  
  /// A reference to all the recorded frames of the recorded view, without the watermark
  private var framesWithoutWatermark = [UIImage]()
  
  /// A reference to all the recorded frames of the recorded view, including the watermark
  private var framesWithWatermark = [UIImage]()

  /// Link to the display refresh rate to monitor and save each frame
  private var displayLink: CADisplayLink?
  
  /// Called when we're done writing the video
  private var completion: ((URL?) -> Void)?
  
  /// The view we're actively recording
  private var recordingView: RecordingView?
  
  /// The watermark for the screen recorder
  private var watermark: UIImage = UIImage()
  
  /// Target frames per second to record the video at
  private var framesPerSecond: Double
  
  private var frameSize: CGSize {
    CGSize(width: (framesWithoutWatermark.first?.size.width ?? 0) * UIScreen.main.scale,
           height: (framesWithoutWatermark.first?.size.height ?? 0) * UIScreen.main.scale)
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
  
  public func startRecording<ContentView, BackgroundView>(
    _ view: ContentView,
    backgroundView: BackgroundView?
  ) where ContentView: View, BackgroundView: View {
    guard let uiView = viewToUIView(view) else { return }
    
    var backgroundUIView: UIView?
    if let backgroundView = backgroundView {
      backgroundUIView = viewToUIView(backgroundView)
    }
    
    startRecording(uiView, backgroundView: backgroundUIView)
  }
  
  public func startRecording(_ view: UIView, backgroundView: UIView?) {
    self.recordingView = constructView(view, backgroundView: backgroundView)
    displayLink = CADisplayLink(target: self, selector: #selector(tick))
    displayLink?.add(to: RunLoop.main, forMode: .common)
  }
  
  public func stopRecording() async throws -> (previewVideoURL: URL, shareVideoURL: URL) {
    displayLink?.invalidate()
    displayLink = nil
    
    guard !framesWithoutWatermark.isEmpty,
          !framesWithWatermark.isEmpty else {
      throw ScreenRecorderError.noFrames
    }
    
    // Remove first frame, which is often a grey transisionary frame as the view gets added
    _ = framesWithoutWatermark.removeFirst()
    _ = framesWithWatermark.removeFirst()

    async let videoWithoutWatermarkURL = writeToVideo(withWatermark: false)
    async let videoWithWatermarkURL = writeToVideo(withWatermark: true)
    
    return try await (videoWithoutWatermarkURL, videoWithWatermarkURL)
  }
  
  public func addWatermark(_ image: UIImage) {
    recordingView?.watermark = image
    watermark = image
  }
  
  public func removeWatermark() {
    recordingView?.watermark = nil
    watermark = UIImage()
  }
  
  /// A method called every screen refresh to capture current visual state of the view
  @objc
  private func tick(_ displayLink: CADisplayLink) {
    guard let recordingView = recordingView else { return }
    
    let renderer = UIGraphicsImageRenderer(size: recordingView.frame.size)
    
    // Save a frame without the watermark (to display in-app)
    recordingView.setWatermarkDisplay(hidden: true)
    
    let frameWithoutWatermark = renderer.image(actions: { _ in
      recordingView.drawHierarchy(in: CGRect(origin: .zero, size: recordingView.frame.size), afterScreenUpdates: true)
    })
    
    // Save a frame with the watermark (to share outside of the ap)
    recordingView.setWatermarkDisplay(hidden: false)
    
    let frameWithWatermark = renderer.image(actions: { _ in
      recordingView.drawHierarchy(in: CGRect(origin: .zero, size: recordingView.frame.size), afterScreenUpdates: true)
    })
    
    framesWithoutWatermark.append(frameWithoutWatermark)
    framesWithWatermark.append(frameWithWatermark)
  }
  
  /// Accumulates all frames and transforms them into an exportable video
  ///
  /// - Parameters:
  ///   - codecType: A video codec type, of type `AVVideoCodecType`. Default is `.h264`
  private func writeToVideo(withWatermark: Bool, codecType: AVVideoCodecType = .h264) async throws -> URL {
    let frames = withWatermark ? framesWithWatermark : framesWithoutWatermark
    
    guard !frames.isEmpty else {
      throw ScreenRecorderError.noFrames
    }
    
    guard framesPerSecond > 0 else {
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
      throw ScreenRecorderError.unableToAddVideoInput
    }
    
    let pixelAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
                                                            sourcePixelBufferAttributes: self.pixelAdaptorAttributes)
    
    writer.startWriting()
    writer.startSession(atSourceTime: CMTime.zero)
    
    var frameIndex: Int = 0
    while frameIndex < frames.count {
      if input.isReadyForMoreMediaData {
        guard let buffer = frames[frameIndex].toSampleBuffer(frameIndex: frameIndex, framesPerSecond: framesPerSecond),
              let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
                throw ScreenRecorderError.unableToCreateSampleBuffer
              }
        
        guard pixelAdaptor.append(imageBuffer, withPresentationTime: CMSampleBufferGetOutputPresentationTimeStamp(buffer)) else {
          throw ScreenRecorderError.unableToAppendBuffer
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
  
  /// Generates a random file URL to temporarily store the recorded video
  private func generateUniqueFileURL() -> URL {
    var fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
    fileURL.appendPathComponent(UUID().uuidString)
    fileURL.appendPathExtension("mov")
    return fileURL
  }
  
  /// Converts a SwiftUI view to a UIView in order to record
  ///
  /// - Parameters:
  ///    - view: A SwiftUI `View` instance to convert into a `UIVIew`
  ///
  /// - Returns: An optional instance of a `UIView`
  private func viewToUIView<ContentView: View>(_ view: ContentView) -> UIView? {
    let controller = UIHostingController(rootView: view.edgesIgnoringSafeArea(.all))
    let view = controller.view
    
    let targetSize = controller.view.intrinsicContentSize
    
    view?.frame = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear
    
    return view
  }
  
  /// Combines the main view as well as an optional `backgroundView` into one layered `UIView`
  ///
  /// - Parameters:
  ///    - sourceView: The primary view to record
  ///    - backgroundView: An optional view to place behind the primary view
  ///
  /// - Returns: A layered `UIView` with the `backgroundView` and `sourceView`
  private func constructView(_ sourceView: UIView, backgroundView: UIView?) -> RecordingView {
    let recordingView = RecordingView(sourceView: sourceView, backgroundView: backgroundView)
    recordingView.watermark = watermark
    return recordingView
  }
}
