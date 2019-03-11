//
//  CoeurMeasureTutorialPageController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

public struct CoeurTutorialPageData {
  let tutorialPageImage: UIImage?
  let tutorialPageTitle: String
  let tutorialPageText: String
  let tutorialPageIndex: Int
}

class CoeurMeasureTutorialPageController: UIViewController {

  @IBOutlet weak var tutorialImageView: UIImageView! {
    didSet {
      tutorialImageView.image = pageData?.tutorialPageImage
    }
  }

  @IBOutlet weak var tutorialImageTitleLabel: UILabel! {
    didSet {
      tutorialImageTitleLabel.text = pageData?.tutorialPageTitle
    }
  }

  @IBOutlet weak var tutorialImageTextLabel: UILabel! {
    didSet {
      tutorialImageTextLabel.text = pageData?.tutorialPageText
    }
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
