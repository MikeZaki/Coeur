//
//  DashboardViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct Constants {
  public static let cardViewOffsetOriginalOffset: CGFloat = -40
}

class DashboardViewController: UIViewController {

  @IBOutlet weak var dashboardCardView: UIView!
  @IBOutlet weak var dashboardCardViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var userProfileImageView: UIImageView!

  static func dashboardViewController() -> DashboardViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true

    // Cardview Setup
    let shadowSize : CGFloat = 6.0
    let shadowRect = CGRect(x: -shadowSize / 2,
                            y: -shadowSize / 2,
                            width: dashboardCardView.frame.size.width + shadowSize / 2,
                            height: dashboardCardView.frame.size.height + shadowSize / 2)
    let shadowPath = UIBezierPath(roundedRect: shadowRect,
                                  byRoundingCorners: [.topLeft, .topRight],
                                  cornerRadii: CGSize(width: 40, height: 40))

    dashboardCardView.layer.shadowColor = Colors.coeurShadowColor.cgColor
    dashboardCardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    dashboardCardView.layer.shadowOpacity = 1.0
    dashboardCardView.layer.shadowPath = shadowPath.cgPath
    dashboardCardView.layer.cornerRadius = 40

    // Profile Image Set up
    userProfileImageView.layer.borderColor = UIColor.black.cgColor
    userProfileImageView.layer.borderWidth = 1
    userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.height / 2

    // Gradient View
    view.layer.insertSublayer(GradientView(
      color1: Colors.coeurSilver,
      color2: .white,
      frame: CGRect(
        x: 0,
        y: 0,
        width: view.bounds.width,
        height: 300
      )
    ).layer, at: 0)
  }

  override func viewDidAppear(_ animated: Bool) {
    dashboardCardViewBottomConstraint.constant = Constants.cardViewOffsetOriginalOffset
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
}
