//
//  FirstRunProfileViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class FirstRunProfileViewController: UIViewController {

  @IBOutlet weak var back: NSLayoutConstraint!


  @IBAction func `continue`(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction func back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
