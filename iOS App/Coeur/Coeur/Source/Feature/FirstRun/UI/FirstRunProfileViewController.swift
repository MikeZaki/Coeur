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
  @IBOutlet weak var finishButton: UIButton!

  override func viewWillAppear(_ animated: Bool) {
    // By Default the button is innactive.
//    finishButton.isEnabled = false
//    finishButton.alpha = 0.5

    finishButton.layer.cornerRadius = finishButton.bounds.height / 2
    finishButton.backgroundColor = .white
    finishButton.layer.borderColor = Colors.coeurGray.cgColor
    finishButton.layer.borderWidth = 1
  }

  @IBAction func back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func onFinishPressed(_ sender: UIButton) {
    // If the user made it this far, save that they have now seen the welcome flow
    UserDefaults.standard.set(true, forKey: CoeurUserDefaultKeys.kHasSeenWelcome)
    self.dismiss(animated: true, completion: nil)
  }
}
