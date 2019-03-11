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
    upperHeartPath.move(to: CGPoint(x: 30.54, y: 148.38))
    upperHeartPath.addLine(to: CGPoint(x: 93.72, y: 147.93))
    upperHeartPath.addLine(to: CGPoint(x: 110.89, y: 117.01))
    upperHeartPath.addLine(to: CGPoint(x: 135.93, y: 165.28))
    upperHeartPath.addLine(to: CGPoint(x: 165.82, y: 90.81))
    upperHeartPath.addLine(to: CGPoint(x: 189.37, y: 180.8))
    upperHeartPath.addLine(to: CGPoint(x: 218.82, y: 147.72))
    upperHeartPath.addLine(to: CGPoint(x: 266.12, y: 148.55))
    upperHeartPath.addLine(to: CGPoint(x: 281.24, y: 115.04))
    upperHeartPath.addLine(to: CGPoint(x: 267.33, y: 64.79))
    upperHeartPath.addLine(to: CGPoint(x: 227.19, y: 39.23))
    upperHeartPath.addLine(to: CGPoint(x: 183.03, y: 45.35))
    upperHeartPath.addLine(to: CGPoint(x: 149.44, y: 70.51))
    upperHeartPath.addLine(to: CGPoint(x: 112.3, y: 44.7))
    upperHeartPath.addLine(to: CGPoint(x: 68.49, y: 40.09))
    upperHeartPath.addLine(to: CGPoint(x: 29.41, y: 64.21))
    upperHeartPath.addLine(to: CGPoint(x: 14.4, y: 100.24))
    upperHeartPath.addLine(to: CGPoint(x: 28.17, y: 145.95))
    UIColor.white.setStroke()
    upperHeartPath.lineWidth = 5
    upperHeartPath.lineCapStyle = .round
    upperHeartPath.lineJoinStyle = .round
    upperHeartPath.stroke()
    return upperHeartPath
  }()

  //// LowerHeart Drawing
  let lowerHeartPath: UIBezierPath = {
    let lowerHeartPath = UIBezierPath()
    lowerHeartPath.move(to: CGPoint(x: 29.5, y: 148.5))
    lowerHeartPath.addLine(to: CGPoint(x: 93.8, y: 147.83))
    lowerHeartPath.addLine(to: CGPoint(x: 111.02, y: 117.03))
    lowerHeartPath.addLine(to: CGPoint(x: 135.82, y: 165.6))
    lowerHeartPath.addLine(to: CGPoint(x: 165.72, y: 90.75))
    lowerHeartPath.addLine(to: CGPoint(x: 188.91, y: 180.63))
    lowerHeartPath.addLine(to: CGPoint(x: 219.17, y: 148.03))
    lowerHeartPath.addLine(to: CGPoint(x: 267.03, y: 148.43))
    lowerHeartPath.addLine(to: CGPoint(x: 214.63, y: 190.68))
    lowerHeartPath.addLine(to: CGPoint(x: 148.18, y: 243.27))
    lowerHeartPath.addLine(to: CGPoint(x: 32.69, y: 152.03))
    UIColor.white.setStroke()
    lowerHeartPath.lineWidth = 5
    lowerHeartPath.lineCapStyle = .round
    lowerHeartPath.lineJoinStyle = .round
    lowerHeartPath.stroke()
    return lowerHeartPath
  }()

  let backgroundImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "CoeurIconiOS_3x.png"))
    return imageView
  }()

  private var upperHeartLayer = CAShapeLayer()
  private var lowerHeartLayer = CAShapeLayer()

  func setup() {
    backgroundColor = .clear

    upperHeartLayer.frame = CGRect(x: 8, y: -5, width: self.frame.size.width, height: self.frame.size.height)
    upperHeartLayer.path = upperHeartPath.cgPath
    upperHeartLayer.lineWidth = 5
    upperHeartLayer.strokeColor = UIColor.white.cgColor
    upperHeartLayer.fillColor = nil
    upperHeartLayer.strokeEnd = 0.0

    lowerHeartLayer.frame = CGRect(x: 8, y: -5, width: self.frame.size.width, height: self.frame.size.height)
    lowerHeartLayer.path = lowerHeartPath.cgPath
    lowerHeartLayer.lineWidth = 5
    lowerHeartLayer.strokeColor = UIColor.white.cgColor
    lowerHeartLayer.fillColor = nil

    backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    addSubview(backgroundImageView)

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
