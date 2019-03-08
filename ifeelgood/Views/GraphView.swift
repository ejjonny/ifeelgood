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
	}
	
	func graphCurrentEntryDataWith(range: GraphRangeOptions,_ completion: @escaping (Bool) -> ()) {
		DispatchQueue.global().sync {
			let entries = CardController.shared.entriesWith(graphViewStyle: range)
			if !entries.isEmpty, entries.count > 1 {
				let valuesToMap = entries.compactMap{ CGFloat($0.rating) }
				self.bezierWithValues(onView: self, YValues: valuesToMap, smoothing: 0.3, inset: 10) { path in
					self.shapeLayer?.path = nil
					self.path = path
					self.setNeedsDisplay()
					completion(true)
				}
			} else {
				DispatchQueue.main.async {
					self.clearGraph()
					completion(false)
				}
			}
		}
	}

	func clearGraph() {
		shapeLayer?.removeFromSuperlayer()
		self.path = nil
		self.setNeedsDisplay()
	}
}
