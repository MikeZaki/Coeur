import Foundation

public class DataProcessor {
  static let NZEROS: Int = 4
  static let NPOLES: Int = 4
  static let dGain: Double = 1.337063846e+02
  static var xv: [Double] = [0,0,0,0,0]
  static var yv: [Double] = [0,0,0,0,0]
  
  public static func butterworthBandpassFilter(inputData: Array<Double>) -> Double {
    guard let input = inputData.last else { return 0 }
    
    xv[0] = xv[1]; xv[1] = xv[2]; xv[2] = xv[3]; xv[3] = xv[4];
    xv[4] = input / dGain;
    yv[0] = yv[1]; yv[1] = yv[2]; yv[2] = yv[3]; yv[3] = yv[4];
    yv[4] =   (xv[0] + xv[4]) - 2 * xv[2]
      + ( -0.7716989200 * yv[0]) + (  3.2728850765 * yv[1])
      + ( -5.2289812210 * yv[2]) + ( 3.7277438390 * yv[3]);
    
    return yv[4]
  }
  
  public static func medianSmooth(inputData: Array<Double>) -> Array<Double> {
    var output: Array<Double> = []
    
    for i  in 0..<inputData.count {
      if (0...3).contains(i) || ((inputData.count - 3)...(inputData.count - 1)).contains(i) {
        output.append(inputData[i])
      } else {
        let medianArray = [
          inputData[i-2],
          inputData[i-1],
          inputData[i],
          inputData[i+1],
          inputData[i+2]
        ]
        
        output.append(medianArray[2])
      }
    }
    
    return output
  }
  
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
