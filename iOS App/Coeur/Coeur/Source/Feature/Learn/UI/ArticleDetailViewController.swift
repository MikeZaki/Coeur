//
//  ArticleDetailViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/12/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

  override func viewWillAppear(_ animated: Bool) {
  }

  @IBAction func back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
