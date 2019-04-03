//
//  SoftShadowedView.swift
//  ifeelgood
//
//  Created by Ethan John on 4/3/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension UIView {
	func addSoftShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.06
		self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
		self.layer.cornerRadius = 10
		self.layer.shadowRadius = 5
	}
}
