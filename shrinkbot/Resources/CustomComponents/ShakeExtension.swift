//
//  ShakeExtension.swift
//  shrinkbot
//
//  Created by Ethan John on 2/6/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension UIView {
	func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.6
		animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
		layer.add(animation, forKey: "shake")
	}
}
