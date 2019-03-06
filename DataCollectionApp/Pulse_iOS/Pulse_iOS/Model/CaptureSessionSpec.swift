//
//  CaptureSessionSpec.swift
//  Pulse_iOS
//
//  Created by Mike Zaki on 2019-02-01.
//  Copyright © 2019 Mike. All rights reserved.
//
import CoreGraphics

/// Defines the Capture Session Preview Specifications.
public struct CaptureSessionSpec {
  var fps: Int32
  var size: CGSize
  
  /// Initializes a CaptureSessionSpec Object.
  ///
  /// - Parameters:
  ///   - fps: The desired frame rate.
  ///   - size: The desired frame size.
  init(fps: Int32, size: CGSize) {
    self.fps = fps
    self.size = size
  }
}
