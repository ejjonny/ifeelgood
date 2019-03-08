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
	var plottedPointsLayer = CAShapeLayer()
	var lineLayer = CAShapeLayer()
	var path: UIBezierPath?
	var dataPoints = 2
	var graphInset = 10
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		self.layer.addSublayer(lineLayer)
		self.layer.addSublayer(plottedPointsLayer)
	}
	
	func drawPlottedPoints() {
		guard let graphPath = self.path else { print("Graph plotted path is nil."); return }
		plottedPointsLayer.path = graphPath.cgPath
		plottedPointsLayer.fillColor = UIColor.clear.cgColor
		plottedPointsLayer.strokeColor = deepChillBlue.cgColor
		plottedPointsLayer.lineWidth = 3
		plottedPointsLayer.lineCap = .round
	}
	
	func drawGridLines() {
		for i in 0..<dataPoints {
			drawVerticalLine(atSegment: i)
		}
		for i in 0...4 {
			drawHorizontalLine(atSegment: i, total: 4)
		}
	}
	
	func drawHorizontalLine(atSegment segment: Int, total: Int) {
		let YAxisMarkLayer = CAShapeLayer()
		let YAxisMark = UIBezierPath()
		YAxisMark.move(to: CGPoint(x: self.frame.minX, y: self.frame.minY + CGFloat(graphInset) + ((self.frame.height - CGFloat((graphInset * 2))) / CGFloat(total) * CGFloat(segment))))
		YAxisMark.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.minY + CGFloat(graphInset) + ((self.frame.height - CGFloat((graphInset * 2))) / CGFloat(total) * CGFloat(segment))))
		YAxisMarkLayer.path = YAxisMark.cgPath
		YAxisMarkLayer.fillColor = UIColor.clear.cgColor
		YAxisMarkLayer.strokeColor = middleChillBlue.cgColor
		YAxisMarkLayer.lineWidth = 1
		YAxisMarkLayer.lineCap = .square
		self.lineLayer.addSublayer(YAxisMarkLayer)
	}
	
	func drawVerticalLine(atSegment segment: Int) {
		let XAxisMarkLayer = CAShapeLayer()
		let XAxisMark = UIBezierPath()
		XAxisMark.move(to: CGPoint(x: self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints - 1) * CGFloat(segment)), y: self.frame.minY))
		XAxisMark.addLine(to: CGPoint(x: self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints - 1) * CGFloat(segment)), y: self.frame.maxY))
		XAxisMarkLayer.path = XAxisMark.cgPath
		XAxisMarkLayer.fillColor = UIColor.clear.cgColor
		XAxisMarkLayer.strokeColor = middleChillBlue.cgColor
		XAxisMarkLayer.lineWidth = 1
		XAxisMarkLayer.lineCap = .square
		self.lineLayer.addSublayer(XAxisMarkLayer)
	}
	
	func graphCurrentEntryDataWith(range: GraphRangeOptions,_ completion: @escaping (Bool) -> ()) {
		DispatchQueue.global().async {
			let entries = CardController.shared.entriesWith(graphViewStyle: range)
			if !entries.isEmpty, entries.count > 1 {
				self.dataPoints = entries.count
				let valuesToMap = entries.compactMap{ CGFloat($0.rating) }
				self.bezierWithValues(onView: self, YValues: valuesToMap, maxY: 5, minY: 1, smoothing: 0.3, inset: CGFloat(self.graphInset)) { path in
					DispatchQueue.main.async {
						self.clearGraph()
						self.path = path
						self.drawGridLines()
						self.drawPlottedPoints()
						self.setNeedsDisplay()
						completion(true)
					}
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
		lineLayer.removeFromSuperlayer()
		plottedPointsLayer.removeFromSuperlayer()
		lineLayer = CAShapeLayer()
		plottedPointsLayer = CAShapeLayer()
		self.path = nil
		self.setNeedsDisplay()
	}
}
