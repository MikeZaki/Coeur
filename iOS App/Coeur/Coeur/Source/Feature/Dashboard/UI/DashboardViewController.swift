//
//  DashboardViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/10/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import Firebase

fileprivate struct Constants {
  public static let cardViewOffsetOriginalOffset: CGFloat = -200
  public static let validCardBottomConstantRange: ClosedRange<CGFloat> = (-200)...(0)
  public static let progressRingsOriginalHeight: CGFloat = 300
  public static let validProgressRingsConstantRange: ClosedRange<CGFloat> = 148...300
}

class DashboardViewController: UIViewController {

  @IBOutlet weak var bloodPressureLabel: UILabel!
  @IBOutlet weak var displaynameLabel: UILabel!
  @IBOutlet weak var progressRingContainer: RingProgressGroupView!
  @IBOutlet weak var dashboardCardView: UIView!
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var dashboardCardStackView: UIStackView!

  @IBOutlet weak var dashboardCardViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressRingsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var iconViewSpacingConstraint: NSLayoutConstraint!

  private var progressRingsStartingHeight: CGFloat = Constants.progressRingsOriginalHeight
  private var cardViewStartingVerticalOffset: CGFloat = Constants.cardViewOffsetOriginalOffset

  private lazy var dashboardCardPanGestureRecognizer: UIPanGestureRecognizer = {
    return UIPanGestureRecognizer(target: self, action: #selector(DashboardViewController.cardViewDidPan))
  }()

  static func dashboardViewController() -> DashboardViewController {
    let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    return newViewController
  }

  override func viewDidLoad() {
    dashboardCardView.addGestureRecognizer(dashboardCardPanGestureRecognizer)
    dashboardCardStackView.addGestureRecognizer(dashboardCardPanGestureRecognizer)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true

    // Cardview Setup
    let shadowSize : CGFloat = 6.0
    let shadowRect = CGRect(x: -shadowSize / 2,
                            y: -shadowSize / 2,
                            width: dashboardCardView.frame.size.width + shadowSize / 2,
                            height: dashboardCardView.frame.size.height + shadowSize / 2)
    let shadowPath = UIBezierPath(roundedRect: shadowRect,
                                  byRoundingCorners: [.topLeft, .topRight],
                                  cornerRadii: CGSize(width: 40, height: 40))

    dashboardCardView.layer.shadowColor = Colors.coeurShadowColor.cgColor
    dashboardCardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    dashboardCardView.layer.shadowOpacity = 1.0
    dashboardCardView.layer.shadowPath = shadowPath.cgPath
    dashboardCardView.layer.cornerRadius = 40

    // Profile Image Set up
    userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.height / 2
    userProfileImageView.clipsToBounds = true

    // Load the user's imageview if it exhists
    if let imageURL = Auth.auth().currentUser?.photoURL {
      guard let largeImageURL = URL(string: imageURL.absoluteString + "?type=large") else { return }
      print("################### IMG URL: \(largeImageURL)")
      userProfileImageView.image(fromUrl: largeImageURL)
    }

    // Load the user's displayName
    if let displayName = Auth.auth().currentUser?.displayName {
      displaynameLabel.text = displayName
    }

    // Gradient View
    view.layer.insertSublayer(GradientView(
      colors: [Colors.coeurSilver, .white],
      frame: CGRect(
        x: 0,
        y: 0,
        width: view.bounds.width,
        height: 300
      )
    ).layer, at: 0)

    guard let bpMeasurements = UserDefaults.standard.array(forKey: CoeurUserDefaultKeys.kBPMeasurements),
          let bp = bpMeasurements.last else {
      bloodPressureLabel.text = "-/-"
      return
    }

    bloodPressureLabel.text = "\(bp)"
  }

  override func viewDidAppear(_ animated: Bool) {
    dashboardCardViewBottomConstraint.constant = Constants.cardViewOffsetOriginalOffset
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }

    // Set Progress Rings
    UIView.animate(
      withDuration: 1.0,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 0.0,
      options: [],
      animations:
      {
        self.progressRingContainer.ring1.progress = Double(arc4random() % 100) / 100.0
        self.progressRingContainer.ring2.progress = Double(arc4random() % 100) / 100.0
    }, completion: nil)
  }

  @objc
  private func cardViewDidPan(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: dashboardCardView)

    switch sender.state {
    case .began:
      print("began")

    case .changed:
      updateViewForTranslation(translation: translation.y)
    case .ended:
      cardViewStartingVerticalOffset = dashboardCardViewBottomConstraint.constant
      progressRingsStartingHeight = progressRingsHeightConstraint.constant

      dashboardCardView.isUserInteractionEnabled = true
      dashboardCardStackView.isUserInteractionEnabled = true

      print("ended")
    default:
      print("Bye")
    }
  }

  private func updateViewForTranslation(translation: CGFloat) {
    let newCardViewPosition = cardViewStartingVerticalOffset - translation
    let newProgressRingsHeight = progressRingsStartingHeight + translation

    dashboardCardView.isUserInteractionEnabled = false
    dashboardCardStackView.isUserInteractionEnabled = false

  // Make sure the new position is valid
    guard Constants.validCardBottomConstantRange.contains(newCardViewPosition) else {
      print("NEW POSITION: \(Int(newCardViewPosition)), CURRENTPOSITION: \(Int(self.dashboardCardViewBottomConstraint.constant)), TRANSLATION: \(Int(translation))")
      return
    }

    guard Constants.validProgressRingsConstantRange.contains(newProgressRingsHeight) else {
      print("NEW POSITION: \(Int(newProgressRingsHeight)), CURRENTPOSITION: \(Int(self.progressRingsHeightConstraint.constant)), TRANSLATION: \(Int(translation))")
      return
    }

    self.progressRingsHeightConstraint.constant = self.progressRingsStartingHeight + translation
    self.dashboardCardViewBottomConstraint.constant = self.cardViewStartingVerticalOffset - translation

    // Update the profile picture's corner radius
    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.bounds.height / 2
    self.progressRingContainer.ringWidth = CGFloat(34) * (newProgressRingsHeight / 300)
    self.iconViewSpacingConstraint.constant = CGFloat(10) * (newProgressRingsHeight / 300)
  }
}
