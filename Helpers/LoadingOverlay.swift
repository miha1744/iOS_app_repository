//
//  LoadingOverlay.swift
//  TestApp
//
//  Created by Иванов Михаил on 05/05/2019.
//  Copyright © 2019 Иванов Михаил. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {

	var overlayView = UIView()
	var activityIndicator = UIActivityIndicatorView()

	static let shared = LoadingOverlay()

	private init() { }

	public func showOverlay(view: UIView) {
		overlayView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 80, height: 80))
		overlayView.center = view.center
		overlayView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		overlayView.clipsToBounds = true
		overlayView.layer.cornerRadius = 10

		activityIndicator.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
		activityIndicator.style = .whiteLarge
		activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

		overlayView.addSubview(activityIndicator)
		view.addSubview(overlayView)

		activityIndicator.startAnimating()
	}

	public func hideOverlayView(view: UIView) {
		activityIndicator.stopAnimating()
		overlayView.removeFromSuperview()
	}
}
