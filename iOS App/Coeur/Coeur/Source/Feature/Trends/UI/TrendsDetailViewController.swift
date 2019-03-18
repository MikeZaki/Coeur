//
//  TrendsDetailViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/12/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class TrendsDetailViewController: UIViewController {

  @IBOutlet weak var rippleView: UIView!

  override func viewWillAppear(_ animated: Bool) {
    rippleView.addRippleEffect(withRippleCount: 3)
    view.layer.insertSublayer(GradientView(colors: [Colors.coeurTrueBlue, Colors.coeurTeal, .white],
                                           locations: [0.0, 0.61, 1.0],
                                           frame: view.bounds).layer, at: 0)
  }

  @IBAction func backButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
}
