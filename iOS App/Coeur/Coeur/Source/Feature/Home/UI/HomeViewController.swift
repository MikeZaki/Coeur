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

  override func viewWillAppear(_ animated: Bool) {
  }

  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    // handle user (`authDataResult.user`) and error as necessary
    print(authDataResult)
  }

  func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
    return SignInViewController(authUI: authUI)
  }

  @IBAction func onSignInPressed(_ sender: UIButton) {
    // Present the auth view controller and then implement the sign in callback.
    let authViewController = authenticatorUI!.authViewController()
    present(authViewController, animated: true, completion: nil)
  }
}
