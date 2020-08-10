//
//  LoginViewController.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import UIKit
import SwiftyJSON

struct LoginUser: Codable {
	let username: String
	let password: String
}

class LoginViewController: UIViewController, NetworkDelegate {

	func showMessage(message: String) {
        DispatchQueue.main.async {
            LoadingOverlay.shared.hideOverlayView(view: self.view)
            let ac = UIAlertController(title: "\(message)", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
            }))
            self.present(ac, animated: true)
        }
	}

	@IBOutlet weak var userNameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	@IBOutlet weak var loginButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		userNameTextField.delegate = self
		passwordTextField.delegate = self
		NetworkManager.shared.delegate = self
		setupUI()
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
		view.addGestureRecognizer(tapGesture)

	}

	func setupUI() {
		userNameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		userNameTextField.layer.borderWidth = 2.0
		userNameTextField.layer.cornerRadius = 10
		userNameTextField.clipsToBounds = true
		passwordTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		passwordTextField.layer.borderWidth = 2.0
		passwordTextField.layer.cornerRadius = 10
		passwordTextField.clipsToBounds = true
		loginButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		loginButton.layer.borderWidth = 2.0
		loginButton.layer.cornerRadius = 10
		loginButton.clipsToBounds = true
	}

	@objc func hideKeyboard(gesture: UITapGestureRecognizer) {
		view.endEditing(true)
	}

	@IBAction func loginButtonTouched(_ sender: Any) {
		LoadingOverlay.shared.showOverlay(view: self.view)
		if let username = userNameTextField.text, let password = passwordTextField.text {
			guard username != "" && password != ""
				else {
					showMessage(message: "Set both username and password")
					return
			}
			let user = LoginUser(username: username, password: password)
			do {
				let jsonData = try JSONEncoder().encode(user)
				NetworkManager.shared.post(path: "/api-token-auth", data: Data(jsonData)) { (data) in
					do {
						let json = try JSON(data: data)
						DispatchQueue.main.sync {
							if let token = json["token"].string {
								UserDefaults.standard.set(token, forKey: "token")
								UserDefaults.standard.set(true, forKey: "loggedIn")
								LoadingOverlay.shared.hideOverlayView(view: self.view)
								self.performSegue(withIdentifier: "LoginSuccessfulSegue", sender: nil)
							} else {
								self.showMessage(message: "Couldn't login, try after a while")
							}
						}
					} catch {
						self.showMessage(message: "Can't decode data!")
					}
				}
			} catch {
				showMessage(message: "Data can't be encoded")
			}
		}
	}
}

extension LoginViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
