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
    trendsCarousel.type = .coverFlow
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
    vc.view.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)

    self.addChild(vc)
    vc.didMove(toParent: self)
    return vc.view
  }

  func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    return value
  }
}
