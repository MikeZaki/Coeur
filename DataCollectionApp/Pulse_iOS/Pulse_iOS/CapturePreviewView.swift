//
//  CapturePreviewView.swift
//  Pulse
//
//  Created by Mike on 2018-10-19.
//  Copyright © 2018 Mike. All rights reserved.
//
import UIKit
import AVFoundation

final class CapturePreviewView: UIView {
  
  let captureSession: AVCaptureSession
  
  init(session: AVCaptureSession) {
    self.captureSession = session

    super.init(frame: .zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
