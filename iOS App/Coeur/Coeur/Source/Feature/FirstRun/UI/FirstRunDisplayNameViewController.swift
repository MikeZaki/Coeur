//
//  FirstRunDisplayNameViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class FirstRunDisplayNameViewController: UIViewController {
  @IBOutlet weak var displaynameTextField: UITextField!

  override func viewWillAppear(_ animated: Bool) {
    displaynameTextField.layer.cornerRadius = 26
  }

  @IBAction func back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
