//
//  ScreenRecorder.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-27.
//

import UIKit
import SwiftUI
import AVFoundation
import os

public protocol ScreenRecorder: AnyObject {
  
  /// Starts recording a SwiftUI view
  ///
  /// - Parameters:
  ///    - view: A SwiftUI view to start recording
  ///    - backgroundView: An optional background view to place behind the main recorded view
  ///    - audioFileURL: The audio to play while recording the video.
  func startRecording<ContentView, BackgroundView>(
    _ view: ContentView,
    backgroundView: BackgroundView?,
    audioFileURL: URL
  ) where ContentView: View, BackgroundView: View
  
  /// Starts recording a UIKit view (UIView)
  ///
  /// - Parameters:
  ///    - view: A UIView to start
  ///    - backgroundView: An optional background view to place behind the main recorded view
  ///    - audioFileURL: The audio to play while recording the video.
  func startRecording(_ view: UIView, backgroundView: UIView?, audioFileURL: URL)
  
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
  
  /// A reference to all the recorded frames of the recorded view
  private var frames = [UIImage]()
  
  /// Link to the display refresh rate to monitor and save each frame
  private var displayLink: CADisplayLink?
  
  /// Called when we're done writing the video
  private var completion: ((URL?) -> Void)?
  
  /// The view we're actively recording
  private var sourceView: UIView?
  
  /// The audio to play while recording the video.
  private var audioFileURL: URL?
  
  /// Target frames per second to record the video at
  private var framesPerSecond: Double
  
  private var frameSize: CGSize {
    CGSize(width: (frames.first?.size.width ?? 0) * UIScreen.main.scale,
           height: (frames.first?.size.height ?? 0) * UIScreen.main.scale)
  }
  
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.services",
    category: "Screen Recorder"
  )
  
  public init(framesPerSecond: Double = 60) {
    self.framesPerSecond = framesPerSecond
  }
  
  public func startRecording<ContentView, BackgroundView>(
    _ view: ContentView,
    backgroundView: BackgroundView?,
    audioFileURL: URL
  ) where ContentView: View, BackgroundView: View {
    guard let uiView = viewToUIView(view) else { return }
    
    var backgroundUIView: UIView?
    if let backgroundView = backgroundView {
      backgroundUIView = viewToUIView(backgroundView)
    }
    
    startRecording(uiView, backgroundView: backgroundUIView, audioFileURL: audioFileURL)
  }
  
  public func startRecording(_ view: UIView, backgroundView: UIView?, audioFileURL: URL) {
    self.audioFileURL = audioFileURL
    sourceView = constructView(view, backgroundView: backgroundView)
    displayLink = CADisplayLink(target: self, selector: #selector(tick))
    displayLink?.add(to: .main, forMode: .common)
  }
  
  public func stopRecording() async throws -> URL {
    displayLink?.invalidate()
    displayLink = nil
    audioFileURL = nil
    
    // Remove first frame, which is often a grey transisionary frame as the view gets added
    _ = frames.popLast()
    
    let videoURL = try await writeToVideo()
    return videoURL
  }
  
  /// A method called every screen refresh to capture current visual state of the view
  @objc
  private func tick(_ displayLink: CADisplayLink) {
    guard let sourceView = sourceView else { return }
    
    let renderer = UIGraphicsImageRenderer(size: sourceView.frame.size)
    
    let frame = renderer.image(actions: { _ in
      sourceView.drawHierarchy(in: CGRect(origin: .zero, size: sourceView.frame.size), afterScreenUpdates: true)
    })
    
    frames.append(frame)
  }
  
  /// Accumulates all frames and transforms them into an exportable video
  ///
  /// - Parameters:
  ///   - codecType: A video codec type, of type `AVVideoCodecType`. Default is `.h264`
  private func writeToVideo(codecType: AVVideoCodecType = .h264) async throws -> URL {
    
    guard !frames.isEmpty else {
      throw ScreenRecorderError.noFrames
    }
    
    guard framesPerSecond > 0 else {
      throw ScreenRecorderError.invalidFPS
    }
    
    // Generate a location for the video (asset) output.
    let url = generateUniqueFileURL()
    
    let writer = try AVAssetWriter(outputURL: url, fileType: .mov)
    
    /*
     *******************
     * Video input
     *******************
     */
    
    // Defines the input of the asset writer to consume the captured frames of the source view.
    let videoSettings: [String: Any] = [
      AVVideoCodecKey: codecType,
      AVVideoWidthKey: frameSize.width,
      AVVideoHeightKey: frameSize.height,
    ]
      
    let videoWriterInput = AVAssetWriterInput(
      mediaType: .video,
      outputSettings: videoSettings
    )
    
    guard writer.canAdd(videoWriterInput) else {
      throw ScreenRecorderError.unableToAddVideoInput
    }
    
    writer.add(videoWriterInput)
    
    let pixelAdaptorAttributes =
    [
      kCVPixelBufferPixelFormatTypeKey as String: Int(kCMPixelFormat_32BGRA),
    ]
    
    // Performance optimization on the captured frame of
    // the source view into pixel buffer.
    let pixelAdaptor = AVAssetWriterInputPixelBufferAdaptor(
      assetWriterInput: videoWriterInput,
      sourcePixelBufferAttributes: pixelAdaptorAttributes)
    
    writer.startWriting()
    writer.startSession(atSourceTime: CMTime.zero)
    
    var frameIndex: Int = 0
    while frameIndex < frames.count {
      if videoWriterInput.isReadyForMoreMediaData {
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
    
    /*
     *******************
     * Audio input
     *******************
     */
    
    guard let audioFileURL = audioFileURL else {
      throw "⚠️ 📺 Couldn't continue the screen recording! No audio file found."
    }

    let audioTrackOutput = try await loadAudioSample(at: audioFileURL)
    
    let outputAudioSettings: [String: Any] = [
      AVFormatIDKey: kAudioFormatLinearPCM,
      AVLinearPCMIsBigEndianKey: false,
      AVLinearPCMIsFloatKey: false,
      AVLinearPCMBitDepthKey: 16,
    ]
    
    let audioWriterInput = AVAssetWriterInput(
      mediaType: .audio,
      outputSettings: outputAudioSettings
    )
    
    guard writer.canAdd(audioWriterInput) else {
      throw "⚠️ 📺 Unable to add the audio input to the asset writer"
    }
    
    writer.add(audioWriterInput)
    
    let queue = DispatchQueue(label: "wtf.nouns.ios.screen-recorder.audio-write")
  requestMediaStream: for await _ in audioWriterInput.requestMediaDataWhenReady(on: queue) {
    
    // while the input is ready for more data, it copies
    // the available samples from the track output
    // and appends them to the input.
    while audioWriterInput.isReadyForMoreMediaData {
      guard let sampleBuffer = audioTrackOutput.copyNextSampleBuffer() else {
        audioWriterInput.markAsFinished()
        break requestMediaStream
      }
      
      guard audioWriterInput.append(sampleBuffer) else {
        throw "⚠️ 📺 Couldn't append the audio sample buffer to the input"
      }
    }
  }
    
    /*
     *******************
     * Completion
     *******************
     */
    
    await writer.finishWriting()
    
    switch writer.status {
    case .completed:
      logger.debug("✅ 📺 Successfully finished writing video \(url.absoluteString)")
      return url
      
    default:
      let error = writer.error ?? ScreenRecorderError.internalError
      logger.error("⚠️ 📺 Finished writing video without success \(error.localizedDescription, privacy: .public)")
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
  private func constructView(_ sourceView: UIView, backgroundView: UIView?) -> UIView {
    guard let backgroundView = backgroundView else {
      return sourceView
    }
    
    let recordingView = RecordingView(sourceView: sourceView, backgroundView: backgroundView)
    
    return recordingView
  }
  
  // MARK: - Audio Sample
  
  private func loadAudioSample(at url: URL) async throws -> AVAssetReaderTrackOutput {
    let asset = AVAsset(url: url)
    _ = try await asset.loadTracks(withMediaType: .audio)
    return try readAudioSamples(from: asset)
  }
  
  private func readAudioSamples(from asset: AVAsset) throws -> AVAssetReaderTrackOutput {
    let assetReader = try AVAssetReader(asset: asset)
    defer { assetReader.startReading() }
    
    guard let track = asset.tracks(withMediaType: .audio).first else {
      throw "⚠️ 📺 Couldn't find tracks that contain media of audio type."
    }
    
    let outputSettings: [String: Any] = [
      AVFormatIDKey: kAudioFormatLinearPCM,
      AVLinearPCMIsBigEndianKey: false,
      AVLinearPCMIsFloatKey: false,
      AVLinearPCMBitDepthKey: 16,
    ]
    
    // Decompress to track to the PCM format.
    let trackOutput = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
    assetReader.add(trackOutput)
    
    return trackOutput
  }
}

extension AVAssetWriterInput {
  
  func requestMediaDataWhenReady(on queue: DispatchQueue) -> AsyncStream<Void> {
    AsyncStream { continuation in
      requestMediaDataWhenReady(on: queue) {
        continuation.yield()
      }
    }
  }
}
