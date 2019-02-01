import UIKit

public class LowPassFilter {
  
  private struct Constants {
    static let alpha: CGFloat = 0.7
  }
  
  public func lowPassFilter(newValue: CGFloat) -> CGFloat {
    struct Filter {
      static var value: CGFloat = 0.0
    }
    
    let previousValue = (Filter.value == 0) ? newValue : Filter.value
    let filteredValue = Constants.alpha * previousValue + (1 - Constants.alpha) * newValue
    Filter.value = filteredValue
    return filteredValue
  }
}
