//
//  SplashViewController.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let defaults = UserDefaults.standard
		if defaults.bool(forKey: "loggedIn") {
			performSegue(withIdentifier: "LoggedInSegue", sender: nil)
		} else {
			performSegue(withIdentifier: "NotLoggedInSegue", sender: nil)
		}
	}

}
