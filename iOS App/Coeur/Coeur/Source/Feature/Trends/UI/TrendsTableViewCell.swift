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
  @IBOutlet weak var labelLabel: UILabel!

  var type: CoeurTrendType?

  public func configure(bp: CoeurBP) {
    statusPill.layer.cornerRadius = statusPill.bounds.height / 2
    statusPill.layer.borderColor = Colors.coeurOrange.cgColor
    statusPill.layer.borderWidth = 1

    valueLabel.text = "\(bp.sys)/\(bp.dia)"
    labelLabel.text = "\(bp.label.rawValue)"
    switch bp.label {
    case .low:
      labelLabel.textColor = Colors.coeurTrueBlue
      statusPill.layer.borderColor = Colors.coeurTrueBlue.cgColor
    case .normal:
      labelLabel.textColor = Colors.coeurTeal
      statusPill.layer.borderColor = Colors.coeurTeal.cgColor
    case .slightlyHigh:
      labelLabel.textColor = Colors.coeurOrange
      statusPill.layer.borderColor = Colors.coeurOrange.cgColor
    case .dangerous:
      labelLabel.textColor = Colors.coeurPink
      statusPill.layer.borderColor = Colors.coeurPink.cgColor
    }
  }
}
