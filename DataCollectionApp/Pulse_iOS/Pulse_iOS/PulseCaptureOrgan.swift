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
    static let frameRate: Float = 60
  }

  private let captureSession = AVCaptureSession()
  let capturePhotoOutput = AVCapturePhotoOutput()
  private var camera: AVCaptureDevice?
  private var captureInput: AVCaptureDeviceInput!
  private let sessionQueue = DispatchQueue(label: "session_queue")

  private var permissionGranted = false

  override init() {
    super.init()

    setupCameraDevice()
    captureSession.sessionPreset = AVCaptureSession.Preset.low
    addInputToSession()
    setupCaptureSettings()
  }

  private func setupCameraDevice() {
    guard let videoCaptureDevice = AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: AVMediaType.video,
      position: .back) else
    {
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
    guard let camera = self.camera else { return }
    let preferredSpec = CaptureSessionSpec(fps: 120, size: CGSize(width: 1920, height: 1080))
    do {
        // update the format with a preferred fps
        camera.updateFormatWithPreferredCaptureSessionSpec(preferredSpec: preferredSpec)
    }
  }

  public func configureTorch() {
    guard let camera = self.camera else { return }
    do {
      try camera.lockForConfiguration()

      camera.torchMode = .on

      camera.unlockForConfiguration()
    } catch {}
  }

  // MARK: Public Interface
  public func add(videoOutput: AVCaptureVideoDataOutput) {
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

  // MARK: I/O
  public func start() {
    sessionQueue.async {
      self.captureSession.startRunning()
    }
  }
}
