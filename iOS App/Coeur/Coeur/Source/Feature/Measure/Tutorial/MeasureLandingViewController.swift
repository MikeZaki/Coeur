//
//  MeasureLandingViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/14/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import Foundation

import UIKit

class MeasureLandingViewController: UIViewController, CoeurTutorialPage {

  static func measureLandingViewController() -> MeasureLandingViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeasureLandingViewController") as! MeasureLandingViewController
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
