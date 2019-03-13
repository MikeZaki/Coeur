//
//  TrendsViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct Constants {
  static let tableViewCellHeight: CGFloat = 100
}

class TrendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var trendsTableView: UITableView!

  static func trendsViewController() -> TrendsTableViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrendsTableViewController") as! TrendsTableViewController
    return newViewController
  }

  override func viewDidLoad() {
    trendsTableView.delegate = self
    trendsTableView.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 8
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendsTableViewCell", for: indexPath) as! TrendsTableViewCell
    cell.configure()
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.tableViewCellHeight
  }
}
