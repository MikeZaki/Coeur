//
//  HomeViewController.swift
//  Coeur
//
//  Created by Sally Moon on 2019-01-23.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  @IBOutlet weak var newUserButton: UIButton!
  @IBOutlet weak var returningUserButton: UIButton!

  private var userDefaults: UserDefaults = UserDefaults.standard
  override func viewDidLoad() {
    setupUI()
  }

  func setupUI() {
    newUserButton.layer.cornerRadius = 10
  }

  func checkLoginState() {
    if let _ = userDefaults.string(forKey: "Coeur_User_Name") {
      // Skip the home page and go straight to dashboard.
    }
  }
}
