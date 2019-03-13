//
//  TrendsViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/13/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import iCarousel

class TrendsViewController: UIViewController, iCarouselDelegate, iCarouselDataSource {

  @IBOutlet var trendsCarousel: iCarousel!

  static func trendsViewController() -> TrendsViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrendsViewController") as! TrendsViewController
    return newViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    trendsCarousel.delegate = self
    trendsCarousel.dataSource = self
    trendsCarousel.type = .linear
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.isHidden = true
  }

  func numberOfItems(in carousel: iCarousel) -> Int {
    return 3
  }

  func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
    guard let view = self.view else { return UIView() }
    let vc = TrendsTableViewController.trendsTableViewController()
    vc.view.frame = CGRect(x: 26, y: 0, width: view.bounds.width - 52, height: view.bounds.height)

    self.addChild(vc)
    vc.didMove(toParent: self)
    return vc.view
  }

  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    if case .spacing = option {
      return value * 1.05
    }

    return value
  }
}
