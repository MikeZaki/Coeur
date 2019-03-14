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

  init(colors: [UIColor], locations: [NSNumber] = [0.0, 0.31, 1.0], frame: CGRect) {
    gl = CAGradientLayer()
    gl.colors = colors.map({ $0.cgColor })
    gl.startPoint = CGPoint(x: 0, y: 0)
    gl.endPoint = CGPoint(x: 0, y: 0.7774)
    gl.locations = locations
    gl.frame = frame

    super.init(frame: frame)

    layer.insertSublayer(gl, at: 0)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
