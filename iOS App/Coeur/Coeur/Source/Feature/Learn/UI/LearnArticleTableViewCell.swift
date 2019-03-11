//
//  LearnArticleTableViewCell.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

class LearnArticleTableViewCell: UITableViewCell {

  @IBOutlet weak var containerView: UIView!

  public func configure() {
    let shadowSize : CGFloat = 2.0
    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                               y: -shadowSize / 2,
                                               width: containerView.frame.size.width + shadowSize / 2,
                                               height: containerView.frame.size.height + shadowSize / 2))
    containerView.layer.masksToBounds = false
    containerView.layer.shadowColor = Colors.coeurShadowColor.cgColor
    containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    containerView.layer.shadowOpacity = 1.0
    containerView.layer.shadowPath = shadowPath.cgPath
  }
}
