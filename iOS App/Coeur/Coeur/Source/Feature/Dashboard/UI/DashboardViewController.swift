//
//  DashboardViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
  static func dashboardViewController() -> DashboardViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
  }
}
