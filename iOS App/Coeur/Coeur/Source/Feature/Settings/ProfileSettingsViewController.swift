//
//  ProfileSettings.swift
//  Coeur
//
//  Created by Michael Zaki on 3/12/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingsViewController: UIViewController {

  @IBOutlet weak var logoutButton: UIButton!

  override func viewWillAppear(_ animated: Bool) {
    logoutButton.layer.cornerRadius = logoutButton.bounds.height / 2
    logoutButton.layer.borderColor = UIColor.black.cgColor
    logoutButton.layer.borderWidth = 1
  }

  @IBAction func back(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func logOut(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
      self.dismiss(animated: true, completion: nil)
    } catch(let error) {
      print(error)
    }
  }
}
