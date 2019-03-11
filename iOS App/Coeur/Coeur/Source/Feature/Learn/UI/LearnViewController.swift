//
//  LearnViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct Constants {
  public static let tableViewCellHeight: CGFloat = 385
}

class LearnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var articleTableView: UITableView!

  static func learnViewController() -> LearnViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LearnViewController") as! LearnViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
  }

  override func viewDidLoad() {
    articleTableView.delegate = self
    articleTableView.dataSource = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LearnArticleTableViewCell", for: indexPath) as! LearnArticleTableViewCell
    cell.configure()
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.tableViewCellHeight
  }
}
