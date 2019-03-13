//
//  TrendsGraphViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/12/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class TrendsGraphViewController: UIViewController {
  @IBOutlet weak var back: UIButton!

  @IBAction func onBackPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
}
