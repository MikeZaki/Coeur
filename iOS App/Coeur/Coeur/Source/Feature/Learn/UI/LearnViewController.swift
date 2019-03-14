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

public struct LearnArticleData {
  let title: String
  let shortDescription: String
  let image: UIImage?
  let fullText: String
}

fileprivate struct LearnArticleDataSource {
  public static let articles = [
    LearnArticleData(title: "High Blood Pressure",
                     shortDescription: "High blood pressure is a common condition in which the long-term force of the blood against your artery walls is high enough that it may [...]",
                     image: UIImage(named: "ArticleImage1.png"),
                     fullText: "Overview High blood pressure is a common condition in which the long-term force of the blood against your artery walls is high enough that it may eventually cause health problems, such as heart disease. Blood pressure is determined both by the amount of blood your heart pumps and the amount of resistance to blood flow in your arteries. The more blood your heart pumps and the narrower your arteries, the higher your blood pressure. You can have high blood pressure (hypertension) for years without any symptoms. Even without symptoms, damage to blood vessels and your heart continues and can be detected. Uncontrolled high blood pressure increases your risk of serious health problems, including heart attack and stroke. High blood pressure generally develops over many years, and it affects nearly everyone eventually. Fortunately, high blood pressure can be easily detected.")
  ]
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
