//
//  MeasureViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/11/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

fileprivate struct Constants {
  public static let iconImageViewOffset: CGFloat = -100
  public static let originalStartButtonWidth: CGFloat = 214
  public static let measurementStartButtonWidth: CGFloat = 330
  public static let originalProgressViewTrailingDistance: CGFloat = 10
  public static let measurementProgressViewTrailingDistance: CGFloat = 320
}

class MeasureViewController: UIViewController {

  @IBOutlet weak var rippleView3: UIView!
  @IBOutlet weak var rippleView2: UIView!
  @IBOutlet weak var resultsView: UIView!
  @IBOutlet weak var rippleView: UIView!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var animatedHeartView: CoeurAnimatedHeartView!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var lastReadingLabel: UILabel!
  @IBOutlet weak var startButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var progressViewTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var lastReadLabelTopConstraint: NSLayoutConstraint!

  public weak var delegate: CoeurTabPageDelegate?

  // Image Capture Vars
  private let captureOrgan: PulseCaptureOrgan = PulseCaptureOrgan()
  private var ppgCSV: [String:Double] = [:]
  private var ppg: [Double] = []
  private var ppgFileURL: URL?

  // Responsible for capturing PPG
  private lazy var ppgOrgan: PulsePPGOrgan = {
    return PulsePPGOrgan(captureOrgan: self.captureOrgan)
  }()

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
    startButton.backgroundColor = Colors.coeurTeal

    animatedHeartView.setup()

    // Add Last Reading Logic
    lastReadingLabel.text = "You haven't taken a measurement yet.\nTry taking one now!"

    // Capture Setup
    ppgOrgan.delegate = self

    animatedHeartView.isHidden = true

    // Load the saved bp measurements.
    guard let bpMeasurements = UserDefaults.standard.array(forKey: CoeurUserDefaultKeys.kBPMeasurements) else { return }
    if bpMeasurements.count > 0 {
      lastReadingLabel.text = "Your Last Measurement\n\(bpMeasurements.first!)"
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    view.layer.insertSublayer(GradientView(colors: [Colors.coeurTrueBlue, Colors.coeurTeal, .white], frame: view.bounds).layer, at: 0)
  }

  private func transformViewForMesurement() {
    // Move the heart Icon and the Start Button.
    startButtonWidthConstraint.constant = Constants.measurementStartButtonWidth
    UIView.animate(withDuration: 0.5, animations: {
      self.view.layoutIfNeeded()

      // Hide the start button title label and show the progress bar.
      self.infoButton.isHidden = true
      self.startButton.setTitleColor(.clear, for: .normal)
      self.lastReadingLabel.isHidden = true
      self.animatedHeartView.isHidden = false
    }) { _ in
      UIView.animate(withDuration: 0.5, animations: {
        self.progressView.isHidden = false
      }) { _ in
        self.progressViewTrailingConstraint.constant = Constants.measurementProgressViewTrailingDistance

        UIView.animate(withDuration: 10, delay: 0.0, options: .curveEaseInOut, animations: {
          self.view.layoutIfNeeded()
        }, completion: { _ in
          self.endMeausurement()
        })
      }
    }
  }

  private func transformViewForResult() {
    progressViewTrailingConstraint.constant = Constants.measurementProgressViewTrailingDistance

    // Set the correct text
    startButton.setTitle("FINISH", for: .normal)
    lastReadingLabel.text = "Your Blood pressure is:\nSlightly High"
    rippleView.addRippleEffect(withRippleCount: 3, delay: 0.1, spacing: 15)
//    rippleView.addRippleEffect()
//    rippleView2.addRippleEffect()
//    rippleView3.addRippleEffect()

    UIView.animate(withDuration: 0.5, animations: {
      self.view.layoutIfNeeded()

      // Hide the start button title label and show the progress bar.
      self.startButton.setTitleColor(.black, for: .normal)
      self.lastReadingLabel.isHidden = false
      self.iconImageView.isHidden = true
      self.animatedHeartView.isHidden = true
      self.progressView.isHidden = true
      self.resultsView.isHidden = true
    }) { _ in
      self.startButtonWidthConstraint.constant = Constants.originalStartButtonWidth
      self.lastReadLabelTopConstraint.constant = 206
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: { _ in })
    }
  }

  private func endMeausurement() {
    // Turn off the flash and Kill the capture session
    transformViewForResult()
    captureOrgan.configureTorch(isOn: false)
    ppgOrgan.kill()

    // DUMMY MEASUREMENT:
    UserDefaults.standard.set(["135/90 mmHg"], forKey: CoeurUserDefaultKeys.kBPMeasurements)

    if ppg.count > 1000 {
      let trimmedPPG = ppg[300...(ppg.count - 1)]
      createJson(from: Array(trimmedPPG))
    }
  }

  func createJson(from ppg:[Double]) {
    let dict: [String: Any] = [ "ppg" : ppg ]
    print(ppg.count)

    let jsonData = try! JSONSerialization.data(withJSONObject: dict)
    let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
    print(jsonString!)

    let fileManager = FileManager.default
    do {
      let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
      let fileURL = path.appendingPathComponent("CSVRec-\(Auth.auth().currentUser?.uid ?? "unkownUser").json")
      self.ppgFileURL = fileURL
      try jsonData.write(to: fileURL)
    } catch {
      print("error creating file")
    }
  }

  @IBAction func onStartButtonPressed(_ sender: UIButton) {
    if ppg.count == 0 {
      delegate?.shouldChangeTabBarVisibility(shown: false)
      transformViewForMesurement()
      animatedHeartView.begin()
      ppgOrgan.beat()
      captureOrgan.configureTorch(isOn: true)
    } else {

      // Here's where shit gets real...
      print("LOADING........")
      guard let ppgJsonURL = self.ppgFileURL else {
        print("NO FILE URL")
        return
      }
      Alamofire.upload(
        ppgJsonURL,
        to: "https://coeur-ios.herokuapp.com/ppg",
        method: .post,
        headers: ["Content-Type":"application/json"]
        ).uploadProgress { progress in
          print("UPLOAD PROGRESS: \(progress.fractionCompleted)")
        }.response(completionHandler: { (response) in
          guard let data = response.data else {
            print("COULD NOT RETRIEVE DATA")
            return
          }

          self.iconImageView.image = UIImage(data: data)
      })

      self.delegate?.shouldChangeDisplay(toPage: .measure)
      self.delegate?.shouldChangeTabBarVisibility(shown: true)
    }
  }

  @IBAction func infoButtonPressed(_ sender: Any) {
    delegate?.shouldChangeDisplay(toPage: .measureTutorial)
  }
}

extension MeasureViewController: ppgOrganDelegate {
  func ppgOrgan(_ ppgOrgan: PulsePPGOrgan, didCapture ppgValue: Double) {
    ppg.append(ppgValue)
  }
}
