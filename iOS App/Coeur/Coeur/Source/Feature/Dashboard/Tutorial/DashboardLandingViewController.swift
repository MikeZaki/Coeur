//
//  DashboardTutorialViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/13/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class DashboardLandingViewController: UIViewController {

  @IBOutlet weak var letsGoButton: UIButton!

  public weak var delegate: CoeurTabPageDelegate?

  static func dashboardLandingViewController() -> DashboardLandingViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardLandingViewController") as! DashboardLandingViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
    letsGoButton.backgroundColor = Colors.coeurLime
    letsGoButton.layer.cornerRadius = letsGoButton.bounds.height / 2
  }


  @IBAction func onLetsGoPressed(_ sender: UIButton) {
    delegate?.shouldChangeDisplay(toPage: .dashboardTutorial)
  }
}
