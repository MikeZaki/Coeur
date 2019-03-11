//
//  MeasureViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class MeasureViewController: UIViewController {

  @IBOutlet weak var startButton: UIButton!

  public weak var delegate: CoeurTabPageDelegate?

  static func measureViewController() -> MeasureViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeasureViewController") as! MeasureViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true

    startButton.layer.cornerRadius = startButton.bounds.height / 2
    startButton.backgroundColor = Colors.coeurLime

    // Gradient
    view.layer.insertSublayer(GradientView(color1: Colors.coeurLime, color2: .white, frame: view.bounds).layer, at: 0)
  }

  @IBAction func infoButtonPressed(_ sender: Any) {
    delegate?.shouldChangeDisplay(toPage: .tutorial)
  }
}
