//
//  SignInViewController.swift
//  Coeur
//
//  Created by Michael Zaki on 3/6/19.
//  Copyright © 2019 Coeur. All rights reserved.
//

import Foundation
import FirebaseUI

class SignInViewController: FUIAuthPickerViewController, UITextFieldDelegate {

  private let signInButton: UIButton = {
    let button = UIButton()
    button.setTitle("SIGN IN", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    button.backgroundColor = Colors.coeurLime
    button.titleLabel?.textAlignment = .center
    button.layer.cornerRadius = 26
    button.layer.shadowColor = Colors.coeurShadowColor.cgColor
    button.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0.5
    button.layer.masksToBounds = false

    // By Default The button is innactive.
    button.alpha = 0.5
    button.isEnabled = false
    button.addTarget(
      self,
      action: #selector(SignInViewController.signIn),
      for: .touchUpInside
    )
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "CoeurIconiOS_3x.png")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let emailTextField: UITextField = {
    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    textField.placeholder = "Email"
    textField.layer.cornerRadius = 26
    textField.backgroundColor = .white
    textField.textAlignment = .center
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.tag = 0 // Identify as email textfield
    return textField
  }()

  private let passwordTextField: UITextField = {
    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    textField.placeholder = "Password"
    textField.layer.cornerRadius = 26
    textField.backgroundColor = .white
    textField.textAlignment = .center
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.tag = 1 // Identify as password textfield
    return textField
  }()

  private let titleLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    label.text = "COEUR"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 36)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let scrollView = view.subviews.first {
      scrollView.backgroundColor = .white
      if let weirdView = scrollView.subviews.first {
        let frame = CGRect(x: 0,
                           y: -308,
                           width: view.bounds.width,
                           height: view.bounds.height + 100)
        weirdView.layer.insertSublayer(GradientView(color1: Colors.coeurLime, color2: .white, frame: frame).layer, at: 0)
      }
    }
    setupUI()
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }

  func setupUI() {
    self.navigationController?.navigationBar.isHidden = true

    view.addSubview(signInButton)
    view.addSubview(emailTextField)
    view.addSubview(passwordTextField)
    view.addSubview(iconImageView)
    view.addSubview(titleLabel)

    iconImageView.heightAnchor.constraint(equalToConstant: 249).isActive = true
    iconImageView.widthAnchor.constraint(equalToConstant: 295).isActive = true
    iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42).isActive = true
    iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true

    titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

    emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 51).isActive = true
    emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
    emailTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
    emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true

    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
    passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
    passwordTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
    passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true

    signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
    signInButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
    signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80.5).isActive = true
    signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80.5).isActive = true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Email Text Field
    if textField.tag == 0 {
      guard let email = textField.text, isValidEmail(testStr: email) else {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        return
      }

      signInButton.isEnabled = true
      signInButton.alpha = 1
    }

    // Password Text Field
    if textField.tag == 1 {
      guard let password = textField.text, password.count > 7 else {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        return
      }

      signInButton.isEnabled = true
      signInButton.alpha = 1
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    // Email Text Field
    if textField.tag == 0 {
      guard let email = textField.text, isValidEmail(testStr: email) else {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        return
      }

      signInButton.isEnabled = true
      signInButton.alpha = 1
    }

    // Password Text Field
    if textField.tag == 1 {
      guard let password = textField.text, password.count > 7 else {
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        return
      }

      signInButton.isEnabled = true
      signInButton.alpha = 1
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true;
  }

  @objc
  func signIn() {
    guard let password = passwordTextField.text, password.count > 7,
          let email = emailTextField.text, isValidEmail(testStr: email)
    else {
      return
    }

    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      print(authResult)
      self.dismiss(animated: true, completion: nil)
    }
  }

  private func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }

  private func emailAndPasswordAreValid() -> Bool {
    return true 
  }
}
