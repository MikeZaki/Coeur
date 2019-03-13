//
//  FirstRunDisplayNameViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/9/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

fileprivate struct Constants {
  public static let validDisplayNameCharacterRange = (3...15)
}

class FirstRunDisplayNameViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var displaynameTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!

  override func viewWillAppear(_ animated: Bool) {
    // By Default the button is innactive.
    continueButton.isEnabled = false
    continueButton.alpha = 0.5

    displaynameTextField.layer.cornerRadius = displaynameTextField.bounds.height / 2
    displaynameTextField.delegate = self
    
    continueButton.layer.cornerRadius = continueButton.bounds.height / 2
    continueButton.backgroundColor = Colors.coeurLime
    hideKeyboardWhenTappedAround()
  }

  @IBAction func back(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentString = textField.text as NSString? else { return true }

    let newString = currentString.replacingCharacters(in: range, with: string)
    guard newString.count <= 15 else {
      // TODO: Show Alert
      return false
    }

    handleFieldsAreValid(isValid: Constants.validDisplayNameCharacterRange.contains(newString.count))
    return true
  }

  private func handleFieldsAreValid(isValid: Bool) {
    if isValid {
      continueButton.isEnabled = true
      continueButton.alpha = 1
    } else {
      continueButton.isEnabled = false
      continueButton.alpha = 0.5
    }
  }

  @IBAction func onContinuePressed(_ sender: UIButton) {
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = displaynameTextField.text
    changeRequest?.commitChanges { (error) in
      guard error == nil else { return }

      UserDefaults.standard.set(self.displaynameTextField.text,
                                forKey: CoeurUserDefaultKeys.kFirebaseUserDisplayName)
    }

    self.performSegue(withIdentifier: "GoToProfileDetail", sender: self)
  }
}
