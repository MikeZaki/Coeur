//
//  UIViewRippleViewExtension.swift
//  Coeur
//
//  Created by Michael Zaki on 3/13/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

extension UIView {

  func addRippleEffect(withRippleCount count: Int, delay: Double = 0.1, spacing: CGFloat = 15) {
    let originalFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.width)

    for i in 0..<count {
      let offset = (CGFloat(i) * spacing)

      let delay = (Double(count - 1) * delay) - (Double(i) * delay)
      let xOffset = originalFrame.minX + offset
      let yOffset = originalFrame.minY + offset
      let width = originalFrame.width - 2 * offset
      let height = originalFrame.height - 2 * offset

      // Generate the frame based on the new scaling
      let rippleFrame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
      let ripplePath = UIBezierPath(ovalIn: rippleFrame)

      let shapePosition = CGPoint(x: rippleFrame.width / 2.0, y: rippleFrame.width / 2.0)
      let rippleShape = CAShapeLayer()
      rippleShape.bounds = CGRect(x: 0, y: 0, width: rippleFrame.width, height: rippleFrame.width)
      rippleShape.path = ripplePath.cgPath
      rippleShape.fillColor = UIColor.clear.cgColor
      rippleShape.strokeColor = UIColor.white.cgColor
      rippleShape.lineWidth = 4
      rippleShape.position = shapePosition
      rippleShape.opacity = 0

      layer.addSublayer(rippleShape)

      addScaleAnimation(toLayer: rippleShape, withDelay: (Double(i) * delay))
    }
  }

  private func addScaleAnimation(toLayer rippleLayer: CAShapeLayer, withDelay delay: Double) {
    let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
    scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1))

    let opacityAnim = CABasicAnimation(keyPath: "opacity")
    opacityAnim.fromValue = 0.7
    opacityAnim.toValue = nil

    let animation = CAAnimationGroup()
    animation.animations = [scaleAnim, opacityAnim]
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    animation.beginTime = CACurrentMediaTime() + delay
    animation.duration = CFTimeInterval(2)
    animation.repeatCount = 25
    animation.isRemovedOnCompletion = true

    rippleLayer.add(animation, forKey: "rippleEffect")
  }
}
