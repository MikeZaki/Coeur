//
//  TrendsViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct Constants {
  static let tableViewCellHeight: CGFloat = 122
}

public struct DataSource {
  public static let data = [
    CoeurBP(sys: 127, dia: 72, label: .slightlyHigh),
    CoeurBP(sys: 115, dia: 70, label: .normal),
    CoeurBP(sys: 118, dia: 68, label: .normal),
    CoeurBP(sys: 130, dia: 70, label: .slightlyHigh),
    CoeurBP(sys: 138, dia: 80, label: .slightlyHigh),
    CoeurBP(sys: 120, dia: 78, label: .normal),
    CoeurBP(sys: 127, dia: 69, label: .slightlyHigh),
  ]
}

class TrendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var trendsTableView: UITableView!

  static func trendsTableViewController() -> TrendsTableViewController {
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
    return DataSource.data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrendsTableViewCell", for: indexPath) as! TrendsTableViewCell
    cell.configure(bp: DataSource.data[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.tableViewCellHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
