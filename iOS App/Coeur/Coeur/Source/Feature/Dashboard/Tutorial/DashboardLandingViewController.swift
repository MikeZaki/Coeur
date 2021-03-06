//
//  DashboardTutorialViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/13/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class DashboardLandingViewController: UIViewController, CoeurTutorialPage {

  static func dashboardLandingViewController() -> DashboardLandingViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardLandingViewController") as! DashboardLandingViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
  }

  private var pageData: CoeurTutorialPageData? {
    didSet {
      pageIndex = pageData?.tutorialPageIndex ?? 0
    }
  }

  public var pageIndex: Int = 0

  func configure(pageData: CoeurTutorialPageData) {
    self.pageData = pageData
  }
}
