//
//  ButtonDepress.swift
//  ifeelgood
//
//  Created by Ethan John on 4/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension UIButton {
	func depress() {
		CardView.animate( withDuration: 0.002, animations: { self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { _ in UIView.animate(withDuration: 0.1) { self.transform = CGAffineTransform.identity}})
	}
}
