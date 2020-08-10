//
//  RegisterViewController.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RegisterUser: Codable {
	let user: LoginUser
	let name: String
}

class RegisterViewController: UIViewController, NetworkDelegate {

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
	@IBOutlet weak var passwordRepetitionTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var registerButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		NetworkManager.shared.delegate = self
		userNameTextField.delegate = self
		passwordTextField.delegate = self
		passwordRepetitionTextField.delegate = self
		nameTextField.delegate = self
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
		view.addGestureRecognizer(tapGesture)
		// Do any additional setup after loading the view.
	}

	@objc func hideKeyboard(gesture: UITapGestureRecognizer) {
		view.endEditing(true)
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
		passwordRepetitionTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		passwordRepetitionTextField.layer.borderWidth = 2.0
		passwordRepetitionTextField.layer.cornerRadius = 10
		passwordRepetitionTextField.clipsToBounds = true
		nameTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		nameTextField.layer.borderWidth = 2.0
		nameTextField.layer.cornerRadius = 10
		nameTextField.clipsToBounds = true

		registerButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		registerButton.layer.borderWidth = 2.0
		registerButton.layer.cornerRadius = 10
		registerButton.clipsToBounds = true
	}

	func checkTextFieldContent() -> Bool {
		guard let username = userNameTextField.text, let password = passwordTextField.text, let passwordRepetition = passwordRepetitionTextField.text, let name = nameTextField.text else {
			showMessage(message: "some fields are nil")
			return false
		}
		if username == "" || password == "" || passwordRepetition == "" || name == "" {
			showMessage(message: "some fields are empty")
			return false
		}
		let range = CharacterSet.letters
		let thereIsLetters = password.rangeOfCharacter(from: range)
		if thereIsLetters == nil {
			showMessage(message: "there are no letters in your password")
			return false
		}
		if password.count < 8 {
			showMessage(message: "there are less than 8 characters")
			return false
		}
		if password != passwordRepetition {
			showMessage(message: "your passwords doesn't match!")
			return false
		}
		return true
	}

	@IBAction func registerButtonTouched(_ sender: Any) {
		guard checkTextFieldContent() else {
			return
		}
		LoadingOverlay.shared.showOverlay(view: self.view)
		let user = RegisterUser(user: LoginUser(username: userNameTextField.text!, password: passwordTextField.text!), name: nameTextField.text!)
		do {
			let jsonData = try JSONEncoder().encode(user)
			NetworkManager.shared.post(path: "/api/v1/register", data: Data(jsonData)) { (data) in
				do {
					let json = try JSON(data: data)
					DispatchQueue.main.sync {
						if let name = json["name"].string, let group = json["group"].string {
							print("Welcome \(name) from group \(group)")
							self.showMessage(message: "Registration Successful")
							self.navigationController?.popViewController(animated: true)
						}
					}
				} catch {
					self.showMessage(message: "can't create json from data from the server")
				}
			}
		} catch {
			showMessage(message: "Can't encode data")
			return
		}
	}

}

extension RegisterViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
