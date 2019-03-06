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

public class PulsePPGOrgan:
  NSObject,
  AVCaptureVideoDataOutputSampleBufferDelegate,
  AVCapturePhotoCaptureDelegate {
  
  private let captureOrgan: PulseCaptureOrgan
  private let lowPassFilter = LowPassFilter()
  private let bufferQueue: DispatchQueue = DispatchQueue(label: "sample_buffer_queue")
  private var frameCount: Int = 0
  private var photoCaptureOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
  weak var delegate: ppgOrganDelegate?
  
  private var ppgData: [ChartDataEntry] = []
  private var hueData: [Double] = []
  private var meanHue: Double {
    return hueData.reduce(0, +) / Double(hueData.count)
  }
  
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
      NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)
    ] as [String : Any]
    
    videoOutput.alwaysDiscardsLateVideoFrames = true
    
    self.captureOrgan.add(videoOutput: videoOutput)
    self.captureOrgan.start()
  }
  
  public func captureOutput(_ output: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//     first we want to grab the pixel buffer from the sample buffer.
    guard let cvimagebuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }

    // increment the frame count
    frameCount += 1

    // We need to lock the buffer so we can manipulate pixel data on the cpu
    CVPixelBufferLockBaseAddress(cvimagebuffer, CVPixelBufferLockFlags(rawValue: 0))
    let yPlanBufferAddress = CVPixelBufferGetBaseAddressOfPlane(cvimagebuffer, 0)
    
    let width = CVPixelBufferGetWidth(cvimagebuffer)
    let height = CVPixelBufferGetHeight(cvimagebuffer)
    
    let buffer = unsafeBitCast(yPlanBufferAddress, to: UnsafeMutablePointer<UInt8>.self)
    let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(cvimagebuffer, 0)
    
    var Y:Float = 0
    for y in stride(from: 0, to: height, by: 10) {
      for x in stride(from: 0, to: bytesPerRow , by: 10) {
        Y += Float(buffer[y * bytesPerRow + x])
      }
    }
    
    let newWidth = width / 10
    let newHeight = height / 10
    let averageY: Double = Double(Y / Float(newWidth * newHeight * 255))

    // before we add the ppg value we need to make sure its valid (after the cuttoff point)
    let filteredHue = Double(lowPassFilter.lowPassFilter(newValue: averageY))
    hueData.append(averageY)

    var smoothedValue = filteredHue
    if frameCount > 5 {
      let end = hueData.count - 1
      let start = hueData.count - 5
      smoothedValue = DataProcessor.butterworthBandpassFilter(inputData: Array(hueData[start...end]))
    }
    
    self.delegate?.ppgOrgan(self, didCapture: smoothedValue)
  
    CVPixelBufferUnlockBaseAddress(cvimagebuffer, CVPixelBufferLockFlags(rawValue: 0))
  }
}

public protocol ppgOrganDelegate: class {
  func ppgOrgan(_ ppgOrgan: PulsePPGOrgan, didCapture ppgValue: Double)
}
