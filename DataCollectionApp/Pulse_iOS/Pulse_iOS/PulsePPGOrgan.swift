//
//  PPGManager.swift
//  Pulse_iOS
//
//  Created by Mike on 2018-10-20.
//  Copyright © 2018 Mike. All rights reserved.
//

import UIKit
import AVFoundation
import Charts
import VideoToolbox

class PulsePPGOrgan:
  NSObject,
  AVCaptureVideoDataOutputSampleBufferDelegate,
  AVCapturePhotoCaptureDelegate {
  
  private let captureOrgan: PulseCaptureOrgan
  private let filterOrgan = FilterOrgan()
  private let bufferQueue: DispatchQueue = DispatchQueue(label: "sample_buffer_queue")
  private var frameCount: Int = 0
  private var ppgData: [ChartDataEntry] = []
  private var hueData: [Double] = []
  private var photoCaptureOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
  
  weak var delegate: ppgOrganDelegate?
  
  init(captureOrgan: PulseCaptureOrgan) {
    self.captureOrgan = captureOrgan
  }
  
  /*
   Starting Op:
   Attach a video output to our capture organ and call start on it
  */
  public func beat() {
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: bufferQueue)
    
    // we need to set the out pixel value to 32bit RGBRA so that we can appropriately manippulate.
    videoOutput.videoSettings = [
      (kCVPixelBufferPixelFormatTypeKey as NSString) :
      NSNumber(value: kCVPixelFormatType_32BGRA as UInt32)
    ] as [String : Any]
    
    videoOutput.alwaysDiscardsLateVideoFrames = false
    
    self.captureOrgan.add(videoOutput: videoOutput)
    self.captureOrgan.start()
  }
  
  
  // MARK: Sample Buffer Delegate
  func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
    // first we want to grab the pixel buffer from the sample buffer.
    guard let cvimagebuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    // increment the frame count
    frameCount += 1
    
    // We need to lock the buffer so we can manipulate pixel data on the cpu
    CVPixelBufferLockBaseAddress(cvimagebuffer, CVPixelBufferLockFlags(rawValue: 0))
    
    let baseAddress = CVPixelBufferGetBaseAddress(cvimagebuffer)
    
    let width = CVPixelBufferGetWidth(cvimagebuffer)
    let height = CVPixelBufferGetHeight(cvimagebuffer)
    
    // Raw Pixel data
    let buffer = unsafeBitCast(baseAddress, to: UnsafeMutablePointer<UInt8>.self)
    let bytesPerRow = CVPixelBufferGetBytesPerRow(cvimagebuffer)
    
    var r:Float = 0
    var g:Float = 0
    var b:Float = 0
    
    for _ in 0..<height {
      for x in stride(from: 0, to: bytesPerRow, by: 4) {
        b += Float(buffer[x])
        g += Float(buffer[x+1])
        r += Float(buffer[x+2])
      }
    }
    
    let averageR: CGFloat = CGFloat(r / Float(width * height * 255))
    let averageG: CGFloat = CGFloat(g / Float(width * height * 255))
    let averageB: CGFloat = CGFloat(b / Float(width * height * 255))
    
    // We want to convert our R, G and B values into a hue value as hue is best for tracking PPG
    // with this particular method. We leverage the UIColor API to do this:
    let frameColor = UIColor(red: averageR, green: averageG, blue: averageB, alpha: 1)
    var hue: CGFloat = 0, sat: CGFloat = 0, bright: CGFloat = 0
    frameColor.getHue(&hue, saturation: &sat, brightness: &bright, alpha: nil)
    
    // Manage Data Entry
    let ppgEntry = ChartDataEntry(x: Double(frameCount),
                                  y: Double(self.filterOrgan.lowPassFilter(newValue: hue)))
    
    hueData.append(Double(self.filterOrgan.lowPassFilter(newValue: hue)))
    
    // We need to keep the stream at a maximum of 100 points so that the
    if ppgData.count > 100 {
      ppgData.removeFirst()
    }
    
    ppgData.append(ppgEntry)
    
    // update the delegate:
    DispatchQueue.main.async {
      self.delegate?.ppgOrganDidBeat(with: self.ppgData)
    }
    
    CVPixelBufferUnlockBaseAddress(cvimagebuffer, CVPixelBufferLockFlags(rawValue: 0))
  }
  
  // MARK: Photo Capture
  func photoCapturePressed() {
    // Make sure capturePhotoOutput is valid
    
    // Get an instance of AVCapturePhotoSettings class
    let photoSettings = AVCapturePhotoSettings()
    
    // Set photo settings for our need
    photoSettings.isDualCameraDualPhotoDeliveryEnabled = true
    
    // Call capturePhoto method by passing our photo settings and a
    // delegate implementing AVCapturePhotoCaptureDelegate
    photoCaptureOutput.capturePhoto(with: photoSettings, delegate: self)
    
    print(photoCaptureOutput.availableRawPhotoPixelFormatTypes)
    
    guard let availableRawFormat = photoCaptureOutput.availableRawPhotoPixelFormatTypes.first else { return }
    let photoSettings2 = AVCapturePhotoSettings(rawPixelFormatType: OSType(availableRawFormat),
                                                processedFormat: [AVVideoCodecKey : AVVideoCodecType.jpeg])
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    
  }
}

public protocol ppgOrganDelegate: class {
  func ppgOrganDidBeat(with values: [ChartDataEntry])
}
