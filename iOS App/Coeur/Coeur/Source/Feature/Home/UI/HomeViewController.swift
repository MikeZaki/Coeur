//
//  HomeViewController.swift
//  Coeur
//
//  Created by Sally Moon on 2019-01-23.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UIViewController, FUIAuthDelegate {

  @IBOutlet weak var newUserButton: UIButton!

  private var userDefaults: UserDefaults = UserDefaults.standard
  private var authenticatorUI: FUIAuth?
  override func viewDidLoad() {
    setupUI()
    setupFirebaseAuth()
  }

  func setupUI() {
    newUserButton.layer.cornerRadius = 26
  }

  func setupFirebaseAuth() {
    FirebaseApp.configure()
    authenticatorUI = FUIAuth.defaultAuthUI()
    // You need to adopt a FUIAuthDelegate protocol to receive callback
    authenticatorUI?.delegate = self

    let providers: [FUIAuthProvider] = [
      FUIGoogleAuth(),
      FUIFacebookAuth(),
    ]
    authenticatorUI?.providers = providers
  }

  override func viewDidAppear(_ animated: Bool) {
    // Check if we have a signed in user
    if let _ = Auth.auth().currentUser {
      showWelcomeIfNeeded()
    }
  }

  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    // handle user (`authDataResult.user`) and error as necessary
    guard let result = authDataResult, error == nil else {
      return
    }
    let user = result.user

    userDefaults.set(user.uid, forKey: CoeurUserDefaultKeys.kFirebaseUserId)
  }

  func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
    return SignInViewController(authUI: authUI)
  }

  @IBAction func onSignInPressed(_ sender: UIButton) {
    // Present the auth view controller and then implement the sign in callback.
    let authViewController = authenticatorUI!.authViewController()
    guard let signInViewController = authViewController.viewControllers.first as? SignInViewController else {
      return
    }

    signInViewController.onEmailSignInCallback = { email, password in
      Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        guard let result = authResult, error == nil else {
          // Display Error
          return
        }
        let user = result.user

        self.userDefaults.set(user.uid, forKey: CoeurUserDefaultKeys.kFirebaseUserId)

        // First Dismiss the Sign In View Controller
        self.dismiss(animated: true, completion: nil)
      }
    }

    present(authViewController, animated: true, completion: nil)
  }

  private func showWelcomeIfNeeded() {
    if userDefaults.bool(forKey: CoeurUserDefaultKeys.kHasSeenWelcome) {
      performSegue(withIdentifier: "GoToDashboard", sender: self)
      return
    }

    performSegue(withIdentifier: "GoToWelcome", sender: self)
  }

  @IBAction func firstRunPressed(_ sender: UIButton) {
    UserDefaults.standard.set(false, forKey: CoeurUserDefaultKeys.kHasSeenWelcome)
    UserDefaults.standard.set(false, forKey: CoeurUserDefaultKeys.kHasSeenLearnLandingPage)
    UserDefaults.standard.set(false, forKey: CoeurUserDefaultKeys.kHasSeenMeasureTutorial)
    UserDefaults.standard.set(false, forKey: CoeurUserDefaultKeys.kHasSeenDashboardTutorial)
  }

}
