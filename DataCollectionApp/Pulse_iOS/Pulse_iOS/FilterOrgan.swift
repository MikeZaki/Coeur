import UIKit

public class FilterOrgan {
  
  private struct Constants {
    static let alpha: CGFloat = 0.7
  }
  
  public func lowPassFilter(newValue: CGFloat) -> CGFloat {
    struct Filter {
      static var value: CGFloat = 0.0
    }
    print(Filter.value)
    let filteredValue = Constants.alpha * ((Filter.value == 0) ? newValue : Filter.value) +
                        (1 - Constants.alpha) * newValue
    Filter.value = filteredValue
    
    return filteredValue
  }
}
