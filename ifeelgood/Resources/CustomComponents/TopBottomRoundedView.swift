//
//  TopBottomRoundedView.swift
//  ifeelgood
//
//  Created by Ethan John on 4/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension UIView {
	func roundBottom(radius: Int) {
		let maskLayer = CAShapeLayer()
		maskLayer.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y - 100), size: CGSize(width: self.bounds.width, height: self.bounds.height + 100)), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
		layer.mask = maskLayer
	}
	
	func roundTop(radius: Int) {
		let maskLayer = CAShapeLayer()
		maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
		layer.mask = maskLayer
	}
	
	func round(radius: Int) {
		let maskLayer = CAShapeLayer()
		maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
		layer.mask = maskLayer
	}
}
