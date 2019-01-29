//
//  CaptureManager.swift
//  Pulse
//
//  Created by Mike on 2018-10-19.
//  Copyright © 2018 Mike. All rights reserved.
//

import Foundation
import AVFoundation

final class PulseCaptureOrgan: NSObject {
  
  struct Constants {
    static let frameRate: Float = 30 
  }
  
  private let captureSession = AVCaptureSession()
  let capturePhotoOutput = AVCapturePhotoOutput()
  private var camera: AVCaptureDevice?
  private var captureInput: AVCaptureDeviceInput!
  private let sessionQueue = DispatchQueue(label: "session_queue")
  
  private var permissionGranted = false
  
  override init() {
    super.init()
    
    requestAccessForMediaDevices()
    setupCameraDevice()
    captureSession.sessionPreset = AVCaptureSessionPresetLow
    addInputToSession()
    setupCaptureSettings()
  }
  
  private func setupCameraDevice() {
    guard let videoCaptureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                                                 mediaType: AVMediaTypeVideo,
                                                                 position: .back) else {
      print("Unable to get camera device.")
      return
    }
    
    self.camera = videoCaptureDevice
  }
  
  // STEP 4: ADD INPUTS TO THE CAMERA SESSION
  private func addInputToSession() {
    guard let bcCamera = self.camera else {
      return
    }
    
    do {
      captureInput = try AVCaptureDeviceInput(device: bcCamera)
    }
    catch {
      /// Handle an error. Input device is not available.
    }
    
    captureSession.beginConfiguration()
    
    guard captureSession.canAddInput(captureInput) else {
      /// Handle an error. We failed to add an input device.
      return
    }
    
    captureSession.addInput(captureInput)
    
    captureSession.commitConfiguration()
  }
  
  private func setupCaptureSettings() {
    /*
     We need to find the lowest resolution frame rate possible. The lower the resolution the easier 
     it is to notice small changes which we will be using to detect the Pulse of the user. 
    */
    guard let camera = self.camera else {
      return
    }
    var currentFormat: AVCaptureDevice.Format = camera.activeFormat// default value.
    camera.formats.forEach({ f in
      guard let format = f as? AVCaptureDevice.Format else { return }
      let frameRates = format.videoSupportedFrameRateRanges[0]
      
      if ((frameRates as! AVFrameRateRange).maxFrameRate == Float64(Constants.frameRate) &&
        (CMVideoFormatDescriptionGetDimensions(format.formatDescription).width <
          CMVideoFormatDescriptionGetDimensions(currentFormat.formatDescription).width &&
          CMVideoFormatDescriptionGetDimensions(format.formatDescription).height < CMVideoFormatDescriptionGetDimensions(currentFormat.formatDescription).height)
        )
      {
        currentFormat = format;
      }
    })
    
    // Once we have the correct format, we now want to set the config on the capture device.
    do {
        // First lock the device for config:
        try camera.lockForConfiguration()
      
        camera.torchMode = .on
        camera.activeFormat = currentFormat
        camera.activeVideoMaxFrameDuration = CMTimeMake(1, Int32(Constants.frameRate)) 
        camera.activeVideoMinFrameDuration = CMTimeMake(1, Int32(Constants.frameRate)) 
        camera.unlockForConfiguration()
    } catch(let error) {
    	print(error)
    }
  }
  
  // MARK: Public Interface
  public func add(videoOutput: AVCaptureVideoDataOutput) {
    guard permissionGranted else { return }
    
    sessionQueue.async {
      guard self.captureSession.canAddOutput(videoOutput) else { return }
      self.captureSession.addOutput(videoOutput)
    }
  }
  
  public func add(photoOutput: AVCapturePhotoOutput) {
    // Get an instance of ACCapturePhotoOutput class
    // Set the output on the capture session
    guard self.captureSession.canAddOutput(self.capturePhotoOutput) else { return }
    self.captureSession.addOutput(self.capturePhotoOutput)
    
    self.capturePhotoOutput.isDualCameraDualPhotoDeliveryEnabled = true
  }
  
  public func requestAccessForMediaDevices() {
    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
      (granted: Bool) -> Void in
      guard granted else {
        /// Report an error. We didn't get access to hardware.
        return
      }
      
      /// All good, access granted.
      self.permissionGranted = true
    }
  }
  
  // MARK: I/O
  public func start() {
    sessionQueue.async { 
      self.captureSession.startRunning()
    }
  }
}
