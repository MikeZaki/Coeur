//
//  CoeurTabBar.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

protocol CoeurTabBarDelegate: class {
  func tabBarButtonPressed(forPage page: CoeurTabBarPage)
}

public struct CoeurTabBarButtonImageSet {
  let selectedImage: UIImage?
  let deselectedImage: UIImage?
}

class CoeurTabBar: UIView {

  // Buttons
  @IBOutlet weak var trendsButton: CoeurTabBarButton!
  @IBOutlet weak var profileButton: CoeurTabBarButton!
  @IBOutlet weak var learnButton: CoeurTabBarButton!
  @IBOutlet weak var measureButton: CoeurTabBarButton!
  @IBOutlet weak var dashboardButton: CoeurTabBarButton!

  // Images
  @IBOutlet weak var communityImageView: UIImageView!
  @IBOutlet weak var learnImageView: UIImageView!
  @IBOutlet weak var measureImageView: UIImageView!
  @IBOutlet weak var trendsImageView: UIImageView!
  @IBOutlet weak var dashboardImageView: UIImageView!

  public weak var delegate: CoeurTabBarDelegate?
  public var currentPage: CoeurTabBarPage = .dashboard {
    willSet(newValue) {
      guard let previousImageView = self.tabBarImages[self.currentPage.rawValue],
            let newImageView = self.tabBarImages[newValue.rawValue]
      else {
          return
      }

      UIView.transition(
        with: newImageView,
        duration:0.3,
        options: .transitionCrossDissolve,
        animations: { previousImageView.image = self.currentPage.imageSet.deselectedImage },
        completion: nil)

      UIView.transition(
        with: newImageView,
        duration:0.3,
        options: .transitionCrossDissolve,
        animations: { newImageView.image = newValue.imageSet.selectedImage },
        completion: nil)
    }
  }

  class func instanceFromNib() -> CoeurTabBar {
    return UINib(nibName: "CoeurTabBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CoeurTabBar
  }

  lazy private var tabBarButtons = [
    dashboardButton,
    trendsButton,
    measureButton,
    learnButton,
    profileButton
  ]

  lazy private var tabBarImages = [
    dashboardImageView,
    trendsImageView,
    measureImageView,
    learnImageView,
    communityImageView
  ]

  func configure() {
    // default view
    currentPage = .dashboard
    dashboardButton.configure(tabBarPage: .dashboard)
    trendsButton.configure(tabBarPage: .trends)
    measureButton.configure(tabBarPage: .measure)
    learnButton.configure(tabBarPage: .learn)
    profileButton.configure(tabBarPage: .community)
  }

  @IBAction func onTabBarButtonPressed(_ sender: UIButton){
    guard let tabBarButton = sender as? CoeurTabBarButton else { return }
    delegate?.tabBarButtonPressed(forPage: tabBarButton.tabBarPage)

    // Update the image of the selected button.
    currentPage = tabBarButton.tabBarPage
  }
}
