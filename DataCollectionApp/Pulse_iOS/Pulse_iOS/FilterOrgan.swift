import UIKit

public class LowPassFilter {
  
  private struct Constants {
    static let alpha: Double = 0.6
  }
  
  public func lowPassFilter(newValue: Double) -> Double {
    struct Filter {
      static var value: Double = 0.0
    }
    
    let previousValue = (Filter.value == 0) ? newValue : Filter.value
    let filteredValue = Constants.alpha * previousValue + (1 - Constants.alpha) * newValue
    Filter.value = filteredValue
    return filteredValue
  }
}
