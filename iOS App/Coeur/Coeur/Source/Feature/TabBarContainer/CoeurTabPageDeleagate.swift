//
//  CoeurTabPageDeleagate.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import Foundation

public protocol CoeurTabPageDelegate: class {
  func shouldChangeDisplay(toPage page: CoeurTabBarPage)
}
