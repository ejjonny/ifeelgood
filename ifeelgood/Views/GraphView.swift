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
	var dateStyle: GraphViewStyles?
	
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
	
	func graphCurrentEntryData(_ completion: @escaping (Bool) -> ()) {

		DispatchQueue.global().sync {
			let entries: [EntryStats]
			if let style = self.dateStyle {
				entries = CardController.shared.entriesWith(graphViewStyle: style)
			} else {
				entries = CardController.shared.entriesWith(graphViewStyle: GraphViewStyles.allTime)
			}
			if !entries.isEmpty {
				let valuesToMap = entries.compactMap{ CGFloat($0.averageRating) }
				self.bezierWithValues(onView: self, YValues: valuesToMap, smoothing: 0.3, inset: 10) { path in
					self.shapeLayer?.path = nil
					self.path = path
					self.setNeedsDisplay()
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
