//
//  GraphView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class GraphView: UIView {

	// MARK: - Params
	var plottedPointsLayer = CAShapeLayer()
	var lineLayer = CAShapeLayer()
	var labels = [UILabel]()
	var path: UIBezierPath?
	var dataPoints: [Entry] = []
	var graphInset = 10
	var graphRange: GraphRangeOptions = .today
	
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
	
	func drawGraph(completion: @escaping (Bool)->(Void)) {
		guard let earliestDate = dataPoints.first?.date else { print("First dataPoint date was nil") ; return }
		let labelStyle: EntryDateStyles
		let delta = abs(earliestDate.timeIntervalSince(Date()))
		// Checks the interval between the earliest date being graphed and now to be able to format graph labels appropriately.
		if delta >= 31557600 {
			labelStyle = .year
		} else if delta >= 2629800 {
			labelStyle = .month
		} else if delta >= 604800 {
			labelStyle = .week
		} else if delta >= 86400 {
			labelStyle = .day
		} else {
			labelStyle = .all
		}
		for point in dataPoints {
			guard point != dataPoints.last else { break }
			guard let date = point.date else {
					print("Date was nil on graph point")
					completion(false)
					return
			}
			var title = ""
			switch labelStyle {
			case .all:
				title = date.asTime()
			case .day:
				title = date.weekSpecific()
			case .week:
				title = date.weekSpecific()
			case .month:
				title = date.asMonthSpecificString()
			case .year:
				title = date.asYearSpecificString()
			}
			createXLabel(atSegment: dataPoints.firstIndex(of: point)!, title: title)
		}
		for i in 0..<dataPoints.count {
			drawVerticalLine(atSegment: i)
		}
		for i in 0...4 {
			drawHorizontalLine(atSegment: i, total: 4)
		}
		completion(true)
	}
	
	func createXLabel(atSegment segment: Int, title: String) {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
		label.textColor = .black
		let width = Int(self.frame.width) - (graphInset * 2) / dataPoints.count
		label.frame = CGRect(origin: CGPoint(x: self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints.count - 1) * CGFloat(segment)), y: self.frame.maxY + 2), size: CGSize(width: CGFloat(width), height: 12))
		label.text = title
		self.labels.append(label)
		self.addSubview(label)
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
		XAxisMark.move(to: CGPoint(x: self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints.count - 1) * CGFloat(segment)), y: self.frame.minY))
		XAxisMark.addLine(to: CGPoint(x: self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints.count - 1) * CGFloat(segment)), y: self.frame.maxY))
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
				// This filters out entries saved with only a factor & no rating so that the graph doesn't try to graph 0.
				self.dataPoints = entries.compactMap{ (entry) -> Entry? in
					if CGFloat(entry.rating) != 0 {
						return entry
					} else {
						return nil
					}
				}
				let valuesToMap = self.dataPoints.map{ CGFloat($0.rating) }
				self.bezierWithValues(onView: self, YValues: valuesToMap, maxY: 5, minY: 1, smoothing: 0.3, inset: CGFloat(self.graphInset)) { path in
					DispatchQueue.main.async {
						self.clearGraph()
						self.path = path
						self.drawGraph(completion: { _ in
							self.drawPlottedPoints()
							self.setNeedsDisplay()
							completion(true)
						})
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
		for label in labels {
			label.removeFromSuperview()
		}
		lineLayer = CAShapeLayer()
		plottedPointsLayer = CAShapeLayer()
		self.path = nil
		self.setNeedsDisplay()
	}
}
