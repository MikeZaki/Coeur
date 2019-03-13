//
//  CoeurTabBarPage.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

public enum CoeurTabBarPage: Int {
  case dashboard = 0
  case trends = 1
  case measure = 2
  case learn = 3
  case community = 4
  case measureTutorial = 5
  case dashboardTutorial = 6

  var imageSet: CoeurTabBarButtonImageSet {
    switch self {
    case .dashboard:
    return  CoeurTabBarButtonImageSet(selectedImage: UIImage(named: "dashboardActiveIcon.png"),
                                      deselectedImage: UIImage(named: "dashboardIcon.png"))
    case .trends:
      return  CoeurTabBarButtonImageSet(selectedImage: UIImage(named: "trendsActiveIcon.png"),
                                        deselectedImage: UIImage(named: "trendsIcon.png"))
    case .measure:
      return  CoeurTabBarButtonImageSet(selectedImage: UIImage(named: "measureActiveIcon.png"),
                                        deselectedImage: UIImage(named: "measureIcon.png"))
    case .learn:
      return  CoeurTabBarButtonImageSet(selectedImage: UIImage(named: "LearnActiveIcon.png"),
                                        deselectedImage: UIImage(named: "LearnIcon.png"))
    case .community:
      return  CoeurTabBarButtonImageSet(selectedImage: UIImage(named: "communityActiveIcon.png"),
                                        deselectedImage: UIImage(named: "communityIcon.png"))
    case .measureTutorial:
      return CoeurTabBarButtonImageSet(selectedImage: nil, deselectedImage: nil)

    case .dashboardTutorial:
      return CoeurTabBarButtonImageSet(selectedImage: nil, deselectedImage: nil)
    }
  }
}
