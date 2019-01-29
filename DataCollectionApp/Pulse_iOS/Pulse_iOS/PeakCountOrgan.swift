//
//  PeakCountOrgan.swift
//  Pulse_iOS
//
//  Created by Mike on 2018-11-03.
//  Copyright © 2018 Mike. All rights reserved.
//

import Foundation

public class PeakCountOrgan {
  
  public static func peaks(for data: Array<Double>) -> Int {
    var peakCount: Int = 0
    
    guard data.count > 6 else { return 0 }
    
    var i = 3
    while i <= data.count - 3 {
      if (data[i] > data[i-1] &&
          data[i] > data[i-2] &&
          data[i] > data[i-3] &&
          data[i] > data[i+1] &&
          data[i] > data[i+2] &&
          data[i] > data[i+3]) {
        
        peakCount += 1
        i += 4
      } else {
        i += 1
      }
    }
    
    return peakCount
  }
}
