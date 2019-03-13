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

  func checkLoginState() {
    if let _ = userDefaults.string(forKey: "Coeur_User_Name") {
      // Skip the home page and go straight to dashboard.
    }
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
    guard let result = authDataResult, error == nil else { return }
    let user = result.user

    userDefaults.set(user.uid, forKey: CoeurUserDefaultKeys.kFirebaseUserId)
    self.showWelcomeIfNeeded()
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
        // First Dismiss the Sign In View Controller
        self.dismiss(animated: true, completion: nil)

        guard let result = authResult, error == nil else {
          // Display Error
          return
        }
        let user = result.user

        self.userDefaults.set(user.uid, forKey: CoeurUserDefaultKeys.kFirebaseUserId)
        self.showWelcomeIfNeeded()
      }
    }

    present(authViewController, animated: true, completion: nil)
  }

  private func showWelcomeIfNeeded() {
    if userDefaults.bool(forKey: CoeurUserDefaultKeys.kkHasSeenWelcome) {
      performSegue(withIdentifier: "GoToDashboard", sender: self)
    }

    performSegue(withIdentifier: "GoToWelcome", sender: self)
  }
}
