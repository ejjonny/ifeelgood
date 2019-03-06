//
//  GraphView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class GraphView: UIView {

	let shapeLayer = CAShapeLayer()
	var path: UIBezierPath?
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		guard let graphPath = self.path else { print("Path is nil - no graph drawn."); return }
		shapeLayer.path = graphPath.cgPath
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.strokeColor = UIColor.black.cgColor
		shapeLayer.lineWidth = 5
		shapeLayer.lineCap = .round
		self.layer.addSublayer(shapeLayer)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
		self.layer.cornerRadius = 10
	}
}
