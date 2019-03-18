//
//  LearnLandingViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class LearnLandingViewController: UIViewController {

  public weak var delegate: CoeurTabPageDelegate?

  static func learnLandingViewController() -> LearnLandingViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LearnLandingViewController") as! LearnLandingViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
  }


  @IBAction func onLetsGoPressed(_ sender: UIButton) {
    delegate?.shouldChangeDisplay(toPage: .learn)
  }
}
