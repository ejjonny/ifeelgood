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
	
	func graphCurrentEntryData(_ completion: @escaping (Bool) -> ()) {
//		switch CardController.shared.entryDateStyle {
//		case .all:
//			let entries = CardController.shared.activeCardEntries
//			if entries.count > 1 {
//				self.bezierWithValues(onView: self, YValues: entries.compactMap{ CGFloat($0.rating) }, smoothing: 0.3, inset: 10) { (path) in
//					self.path = path
//					self.setNeedsDisplay()
//					completion(true)
//					return
//				}
//			} else {
//				self.clearGraph()
//				completion(false)
//				return
//			}
//		default:
//			let entries = CardController.shared.entriesWithDateStyle()
//			if entries.count > 1 {
//				bezierWithValues(onView: self, YValues: entries.compactMap{ CGFloat($0.averageRating)}, smoothing: 0.3, inset: 10) { path in
//					self.path = path
//					self.setNeedsDisplay()
//					completion(true)
//					return
//				}
//			} else {
//				self.clearGraph()
//				completion(false)
//				return
//			}
//		}
		DispatchQueue.global().sync {
			CardController.shared.entryDateStyle = .day
			let entries = CardController.shared.entriesWithDateStyle()
			let valuesToMap = entries.compactMap{ CGFloat($0.averageRating) }
			self.bezierWithValues(onView: self, YValues: valuesToMap, smoothing: 0.3, inset: 10) { path in
				self.path = path
				self.setNeedsDisplay()
			}
		}
	}

	func clearGraph() {
		shapeLayer?.removeFromSuperlayer()
		self.path = nil
		self.setNeedsDisplay()
	}
}
