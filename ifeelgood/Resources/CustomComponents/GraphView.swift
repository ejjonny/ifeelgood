//
//  GraphView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class GraphView: UIView {

	// Mark: - Params
	var shapeLayer: CAShapeLayer? = CAShapeLayer()
	var path: UIBezierPath?
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		guard let graphPath = self.path else { print("Path is nil - no graph drawn."); return }
		guard let layer = shapeLayer else { return }
		layer.path = graphPath.cgPath
		layer.fillColor = UIColor.clear.cgColor
		layer.strokeColor = UIColor.black.cgColor
		layer.lineWidth = 5
		layer.lineCap = .round
		self.layer.addSublayer(layer)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
		self.layer.cornerRadius = 10
	}
	
	func clearGraph() {
		shapeLayer?.removeFromSuperlayer()
		self.path = nil
		self.setNeedsDisplay()
	}
}
