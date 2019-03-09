//
//  GradientView.swift
//  Coeur
//
//  Created by Michael Zaki on 3/7/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class GradientView: UIView {
  var gl:CAGradientLayer

  init(color1: UIColor, color2: UIColor, frame: CGRect) {
    let colorTop = color1.cgColor
    let colorBottom = color2.cgColor

    gl = CAGradientLayer()
    gl.colors = [colorTop, colorBottom]
    gl.startPoint = CGPoint(x: 0, y: 0)
    gl.endPoint = CGPoint(x: 0, y: 0.8091)
    gl.locations = [0.0, 1.0]
    gl.frame = frame

    super.init(frame: frame)

    layer.insertSublayer(gl, at: 0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
