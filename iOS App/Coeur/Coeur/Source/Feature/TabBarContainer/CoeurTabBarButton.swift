//
//  TabBarButton.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class CoeurTabBarButton: UIButton {

  var tabBarPage: CoeurTabBarPage = .dashboard

  public func configure(tabBarPage: CoeurTabBarPage) {
    self.tabBarPage = tabBarPage
  }
}
