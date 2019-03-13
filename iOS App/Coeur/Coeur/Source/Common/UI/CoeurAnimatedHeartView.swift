//
//  CoeurAnimatedHeart.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class CoeurAnimatedHeartView: UIView {
  //// UpperHeart Drawing
  let upperHeartPath: UIBezierPath = {
    let upperHeartPath = UIBezierPath()
    upperHeartPath.move(to: CGPoint(x: 31.92, y: 142.19))
    upperHeartPath.addLine(to: CGPoint(x: 98.09, y: 141.72))
    upperHeartPath.addLine(to: CGPoint(x: 116.07, y: 109.34))
    upperHeartPath.addLine(to: CGPoint(x: 142.29, y: 159.89))
    upperHeartPath.addLine(to: CGPoint(x: 173.59, y: 81.9))
    upperHeartPath.addLine(to: CGPoint(x: 198.26, y: 176.14))
    upperHeartPath.addLine(to: CGPoint(x: 229.1, y: 141.5))
    upperHeartPath.addLine(to: CGPoint(x: 278.63, y: 142.37))
    upperHeartPath.addLine(to: CGPoint(x: 294.46, y: 107.28))
    upperHeartPath.addLine(to: CGPoint(x: 279.89, y: 54.65))
    upperHeartPath.addLine(to: CGPoint(x: 237.86, y: 27.89))
    upperHeartPath.addLine(to: CGPoint(x: 191.62, y: 34.29))
    upperHeartPath.addLine(to: CGPoint(x: 156.44, y: 60.65))
    upperHeartPath.addLine(to: CGPoint(x: 117.54, y: 33.62))
    upperHeartPath.addLine(to: CGPoint(x: 71.67, y: 28.79))
    upperHeartPath.addLine(to: CGPoint(x: 30.75, y: 54.05))
    upperHeartPath.addLine(to: CGPoint(x: 15.02, y: 91.78))
    upperHeartPath.addLine(to: CGPoint(x: 31.85, y: 142.37))
    UIColor.red.setStroke()
    upperHeartPath.lineWidth = 6
    upperHeartPath.lineCapStyle = .round
    upperHeartPath.lineJoinStyle = .round
    upperHeartPath.stroke()
    return upperHeartPath
  }()

  //// LowerHeart Drawing
  let lowerHeartPath: UIBezierPath = {
    let lowerHeartPath = UIBezierPath()
    lowerHeartPath.move(to: CGPoint(x: 33.24, y: 143.69))
    lowerHeartPath.addLine(to: CGPoint(x: 98.99, y: 143.01))
    lowerHeartPath.addLine(to: CGPoint(x: 116.59, y: 111.51))
    lowerHeartPath.addLine(to: CGPoint(x: 141.94, y: 161.17))
    lowerHeartPath.addLine(to: CGPoint(x: 172.52, y: 84.63))
    lowerHeartPath.addLine(to: CGPoint(x: 196.23, y: 176.54))
    lowerHeartPath.addLine(to: CGPoint(x: 227.17, y: 143.2))
    lowerHeartPath.addLine(to: CGPoint(x: 276.11, y: 143.61))
    lowerHeartPath.addLine(to: CGPoint(x: 222.53, y: 186.82))
    lowerHeartPath.addLine(to: CGPoint(x: 154.59, y: 240.59))
    lowerHeartPath.addLine(to: CGPoint(x: 33.66, y: 143.91))
    UIColor.red.setStroke()
    lowerHeartPath.lineWidth = 6
    lowerHeartPath.lineCapStyle = .round
    lowerHeartPath.lineJoinStyle = .round
    lowerHeartPath.stroke()
    return lowerHeartPath
  }()

  private var upperHeartLayer = CAShapeLayer()
  private var lowerHeartLayer = CAShapeLayer()

  func setup() {
    backgroundColor = .clear
    let strokeColor = UIColor.black.cgColor
    upperHeartLayer.frame = CGRect(x: 2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    upperHeartLayer.path = upperHeartPath.cgPath
    upperHeartLayer.lineWidth = 6
    upperHeartLayer.strokeColor = strokeColor
    upperHeartLayer.fillColor = nil
    upperHeartLayer.lineCap = .round
    upperHeartLayer.lineJoin = .round

    lowerHeartLayer.frame = CGRect(x: 2, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    lowerHeartLayer.path = lowerHeartPath.cgPath
    lowerHeartLayer.lineWidth = 6
    lowerHeartLayer.strokeColor = strokeColor
    lowerHeartLayer.fillColor = nil
    lowerHeartLayer.lineCap = .round
    lowerHeartLayer.lineJoin = .round

    layer.addSublayer(upperHeartLayer)
    layer.addSublayer(lowerHeartLayer)
  }

  let strokeEndAnimation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 1
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

    let group = CAAnimationGroup()
    group.duration = 1.5
    group.repeatCount = MAXFLOAT
    group.animations = [animation]

    return group
  }()

  let strokeStartAnimation: CAAnimation = {
    let animation = CABasicAnimation(keyPath: "strokeStart")
    animation.beginTime = 0.5
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 1
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

    let group = CAAnimationGroup()
    group.duration = 1.5
    group.repeatCount = MAXFLOAT
    group.animations = [animation]

    return group
  }()

  func begin() {
    upperHeartLayer.isHidden = false
    upperHeartLayer.add(strokeEndAnimation, forKey: "strokeEnd")
    upperHeartLayer.add(strokeStartAnimation, forKey: "strokeStart")

    lowerHeartLayer.isHidden = false
    lowerHeartLayer.add(strokeEndAnimation, forKey: "strokeEnd")
    lowerHeartLayer.add(strokeStartAnimation, forKey: "strokeStart")
  }

  func end() {
    lowerHeartLayer.removeAllAnimations()
    upperHeartLayer.removeAllAnimations()
  }
}
