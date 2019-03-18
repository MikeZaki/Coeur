//
//  CoeurBP.swift
//  Coeur
//
//  Created by Michael Zaki on 3/14/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

enum CoeurBPLabel: String {
  case low = "Low"
  case normal = "Normal"
  case slightlyHigh = "Slightly High"
  case dangerous = "Dangerous"
}

public class CoeurBP {

  var sys: Int
  var dia: Int
  var label: CoeurBPLabel

  init(bpClass: CGFloat) {
    if (0..<1).contains(bpClass) {
      let percentageTo1sys = bpClass * (20)
      sys = Int(90 + percentageTo1sys)

      let percentageTo1dia = bpClass * (10)
      dia = Int(50 + percentageTo1dia)

      label = .low
      return
    } else if (1..<2).contains(bpClass) {
      let percentageTo1sys = (bpClass - 1) * (15)
      sys = Int(110 + percentageTo1sys)

      let percentageTo1dia = (bpClass - 1) * (15)
      dia = Int(65 + percentageTo1dia)

      label = .normal
      return
    } else if (2..<3).contains(bpClass) {
      let percentageTo1sys = (bpClass - 2) * (10)
      sys = Int(125 + percentageTo1sys)

      let percentageTo1dia = (bpClass - 2) * (10)
      dia = Int(80 + percentageTo1dia)

      label = .slightlyHigh
      return
    } else if bpClass >= 3 {
      let percentageTo1sys = (bpClass - 3) * (10)
      sys = Int(135 + percentageTo1sys)

      let percentageTo1dia = (bpClass - 3) * (10)
      dia = Int(90 + percentageTo1dia)

      label = .dangerous
      return
    }

    sys = 123
    dia = 86
    label = .normal
  }

  init(sys: CGFloat, dia: CGFloat, label: CoeurBPLabel) {
    self.sys = Int(sys)
    self.dia = Int(dia)
    self.label = label
  }

}
