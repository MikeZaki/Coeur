//
//  TrendsTableViewCell.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

public enum CoeurTrendType {
  case bloodPressure
  case heartRate
}

class TrendsTableViewCell: UITableViewCell {
  @IBOutlet weak var statusPill: UIView!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  var type: CoeurTrendType?

  public func configure() {
    statusPill.layer.cornerRadius = statusPill.bounds.height / 2
    statusPill.layer.borderColor = Colors.coeurOrange.cgColor
    statusPill.layer.borderWidth = 1
  }
}
