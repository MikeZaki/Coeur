//
//  MeasureViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit

fileprivate struct Constants {
  public static let iconImageViewOffset: CGFloat = -100
  public static let originalStartButtonWidth: CGFloat = 214
  public static let measurementStartButtonWidth: CGFloat = 330
  public static let originalProgressViewTrailingDistance: CGFloat = 10
  public static let measurementProgressViewTrailingDistance: CGFloat = 320
}

class MeasureViewController: UIViewController {

  @IBOutlet weak var animatedHeartView: CoeurAnimatedHeartView!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var lastReadingLabel: UILabel!
  @IBOutlet weak var iconImageViewVerticalConstraint: NSLayoutConstraint!
  @IBOutlet weak var startButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var progressViewTrailingConstraint: NSLayoutConstraint!

  public weak var delegate: CoeurTabPageDelegate?

  static func measureViewController() -> MeasureViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeasureViewController") as! MeasureViewController
    return newViewController
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController?.navigationBar.isHidden = true

    // Progress view is hidden by default.
    progressView.isHidden = true
    progressView.layer.cornerRadius = progressView.bounds.height / 2

    startButton.layer.cornerRadius = startButton.bounds.height / 2
    startButton.backgroundColor = Colors.coeurLime

    animatedHeartView.setup()

    // Add Last Reading Logic
    lastReadingLabel.text = "You haven't taken a measurement yet.\nTry taking one now!"

    // Gradient
    view.layer.insertSublayer(GradientView(color1: Colors.coeurLime, color2: .white, frame: view.bounds).layer, at: 0)
  }

  @IBAction func infoButtonPressed(_ sender: Any) {
    delegate?.shouldChangeDisplay(toPage: .tutorial)
  }

  private func transformViewForMesurement() {
    // Move the heart Icon and the Start Button.
    iconImageViewVerticalConstraint.constant = Constants.iconImageViewOffset
    startButtonWidthConstraint.constant = Constants.measurementStartButtonWidth
    UIView.animate(withDuration: 0.5, animations: {
      self.view.layoutIfNeeded()

      // Hide the start button title label and show the progress bar.
      self.infoButton.isHidden = true
      self.startButton.setTitleColor(.clear, for: .normal)
      self.lastReadingLabel.isHidden = true
    }) { _ in
      UIView.animate(withDuration: 0.5, animations: {
        self.progressView.isHidden = false
      }) { _ in
        self.progressViewTrailingConstraint.constant = Constants.measurementProgressViewTrailingDistance

        UIView.animate(withDuration: 10, delay: 0.0, options: .curveEaseInOut, animations: {
          self.view.layoutIfNeeded()
        }, completion: nil)
      }
    }
  }

  @IBAction func onStartButtonPressed(_ sender: UIButton) {
    delegate?.shouldChangeTabBarVisibility(shown: false)
    transformViewForMesurement()
    animatedHeartView.begin()
  }
}
