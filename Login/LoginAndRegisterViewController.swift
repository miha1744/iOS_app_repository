//
//  LoginAndRegisterViewController.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import UIKit

class LoginAndRegisterViewController: UIViewController {

	@IBOutlet weak var loginButton: UIButton!

	@IBOutlet weak var registerButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		// Do any additional setup after loading the view.
	}

	func setupUI() {
		self.title = "Welcome!"
		loginButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		loginButton.layer.borderWidth = 2.0
		loginButton.layer.cornerRadius = 10
		loginButton.clipsToBounds = true
		registerButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		registerButton.layer.borderWidth = 2.0
		registerButton.layer.cornerRadius = 10
		registerButton.clipsToBounds = true
	}

	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
