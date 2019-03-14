//
//  FirstRunViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class FirstRunLandingViewController: UIViewController {

  @IBOutlet weak var getStartedButton: UIButton!

  override func viewWillAppear(_ animated: Bool) {
    getStartedButton.layer.cornerRadius = getStartedButton.bounds.height / 2
    getStartedButton.backgroundColor = .white
    getStartedButton.layer.borderColor = Colors.coeurGray.cgColor
    getStartedButton.layer.borderWidth = 1
  }
}
