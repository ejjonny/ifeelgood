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
	var factorLayer = CAShapeLayer()
	var labels = [UILabel]()
	var path: UIBezierPath?
	var dataPoints: [EntryStats] = []
	var graphInset = 10
	var graphRange: GraphRangeOptions = .thisWeek
	var verticalSegments = 4
	var factorColors = [#colorLiteral(red: 0.7883887887, green: 0.7393109202, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8194651824, blue: 0.894031874, alpha: 1), #colorLiteral(red: 1, green: 0.9575231352, blue: 0.7737829244, alpha: 1), #colorLiteral(red: 0.7617713751, green: 1, blue: 0.8736094954, alpha: 1), #colorLiteral(red: 0.9207964755, green: 0.6802755262, blue: 1, alpha: 1), #colorLiteral(red: 0.7044421855, green: 0.9814820289, blue: 1, alpha: 1)]
	var displayedFactorTypes: [FactorType] = []
	
	// MARK: - Lifecycle
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		self.layer.addSublayer(lineLayer)
		self.layer.addSublayer(factorLayer)
		self.layer.addSublayer(plottedPointsLayer)
	}
	
	// MARK: - Graph control
	func graphCurrentEntryDataWith(range: GraphRangeOptions,_ completion: @escaping (Bool) -> ()) {
		DispatchQueue.global().async {
			let entryStats = CardController.shared.entriesWith(graphViewStyle: range)
			if !entryStats.isEmpty, entryStats.count > 1 {
				let valuesToMap = entryStats.map{ CGFloat($0.averageRating) }
				self.dataPoints = entryStats
				self.bezierWithValues(onView: self, YValues: valuesToMap, maxY: 5, minY: 1, smoothing: 0.3, inset: CGFloat(self.graphInset)) { path in
					DispatchQueue.main.async {
						self.clearGraph()
						self.path = path
						self.drawGraphLinesAndLabels(completion: { _ in
							self.drawPath()
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
		factorLayer.removeFromSuperlayer()
		for label in labels {
			label.removeFromSuperview()
		}
		lineLayer = CAShapeLayer()
		plottedPointsLayer = CAShapeLayer()
		factorLayer = CAShapeLayer()
		self.path = nil
		self.setNeedsDisplay()
	}
	
	// MARK: - Supplementary drawing
	private func drawPath() {
		guard let graphPath = self.path else { print("Graph plotted path is nil.") ; return }
		plottedPointsLayer.path = graphPath.cgPath
		plottedPointsLayer.fillColor = UIColor.clear.cgColor
		plottedPointsLayer.strokeColor = UIColor.black.cgColor
		plottedPointsLayer.lineWidth = 3
		plottedPointsLayer.lineCap = .round
	}
	
	private func drawFactorMarks(segment: Int, colorIndexes: [Int]) {
		var lastYEndPoint: CGFloat? = nil
		if colorIndexes.count > 1 {
			print(colorIndexes.count)
		}
		for i in 1...colorIndexes.count {
			let singleFactorMarkLayer = CAShapeLayer()
			let XAxisMark = UIBezierPath()
			let xCoord = relativeXWith(segment: segment)
			XAxisMark.move(to: CGPoint(x: xCoord, y: lastYEndPoint ?? self.frame.minY + 1))
			let YEndPoint = ((self.frame.maxY - 1) / CGFloat(colorIndexes.count)) * CGFloat(i)
			lastYEndPoint = YEndPoint
			XAxisMark.addLine(to: CGPoint(x: xCoord, y: YEndPoint))
			singleFactorMarkLayer.path = XAxisMark.cgPath
			singleFactorMarkLayer.strokeColor = self.factorColors[colorIndexes[i - 1]].cgColor
			singleFactorMarkLayer.lineWidth = 2
			singleFactorMarkLayer.lineCap = .square
			factorLayer.addSublayer(singleFactorMarkLayer)
		}
	}
	
	private func drawGraphLinesAndLabels(completion: @escaping (Bool) -> (Void)) {
		var densityReduction = 1
		switch graphRange {
		case .allTime:
			densityReduction = Int(dataPoints.count / 5)
		case .thisMonth:
			densityReduction = 5
		default:
			break
		}
		for i in 0..<(dataPoints.count / densityReduction) {
			guard dataPoints.indices.contains(i * densityReduction),
				dataPoints[i * densityReduction] != dataPoints.last else { continue }
			createXLabel(atSegment: i * densityReduction, title: dataPoints[i * densityReduction].name)
		}
		for i in 0..<dataPoints.count {
			drawVerticalLine(atSegment: i)
			if !dataPoints[i].factorTypes.isEmpty {
				var colorIndexes = [Int]()
				for type in dataPoints[i].factorTypes {
					guard let index = CardController.shared.activeCardFactorTypes.firstIndex(of: type) else { print("Mark has no type set / is not in array of types") ; return }
					colorIndexes.append(index)
				}
				drawFactorMarks(segment: i, colorIndexes: colorIndexes)
			}
		}
		for i in 0...4 {
			drawHorizontalLine(atSegment: i)
		}
		completion(true)
	}
	
	private func createXLabel(atSegment segment: Int, title: String) {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
		label.textColor = .black
		let width = Int(self.frame.width) - (graphInset * 2) / dataPoints.count
		label.frame = CGRect(origin: CGPoint(x: relativeXWith(segment: segment), y: self.frame.maxY + 2), size: CGSize(width: CGFloat(width), height: 12))
		label.text = title
		self.labels.append(label)
		self.addSubview(label)
	}
	
	private func drawHorizontalLine(atSegment segment: Int) {
		let YAxisMarkLayer = CAShapeLayer()
		let YAxisMark = UIBezierPath()
		let yCoord = relativeYWith(segment: segment)
		YAxisMark.move(to: CGPoint(x: self.frame.minX, y: yCoord))
		YAxisMark.addLine(to: CGPoint(x: self.frame.maxX, y: yCoord))
		YAxisMarkLayer.path = YAxisMark.cgPath
		YAxisMarkLayer.fillColor = UIColor.clear.cgColor
		YAxisMarkLayer.strokeColor = middleChillBlue.cgColor
		YAxisMarkLayer.lineWidth = 1
		YAxisMarkLayer.lineCap = .square
		self.lineLayer.addSublayer(YAxisMarkLayer)
	}
	
	private func drawVerticalLine(atSegment segment: Int) {
		let XAxisMarkLayer = CAShapeLayer()
		let XAxisMark = UIBezierPath()
		let xCoord = relativeXWith(segment: segment)
		XAxisMark.move(to: CGPoint(x: xCoord, y: self.frame.minY))
		XAxisMark.addLine(to: CGPoint(x: xCoord, y: self.frame.maxY))
		XAxisMarkLayer.path = XAxisMark.cgPath
		XAxisMarkLayer.fillColor = UIColor.clear.cgColor
		XAxisMarkLayer.strokeColor = middleChillBlue.cgColor
		XAxisMarkLayer.lineWidth = 1
		XAxisMarkLayer.lineCap = .square
		self.lineLayer.addSublayer(XAxisMarkLayer)
	}
	
	/// Calculates an X coordinate relative to the number of datapoints
	private func relativeXWith(segment: Int) -> CGFloat {
		return self.frame.minX + CGFloat(graphInset) + ((self.frame.width - CGFloat((graphInset * 2))) / CGFloat(dataPoints.count - 1) * CGFloat(segment))
	}
	
	/// Calculates an X coordinate relative to the number of vertical segments
	private func relativeYWith(segment: Int) -> CGFloat {
		return self.frame.minY + CGFloat(graphInset) + ((self.frame.height - CGFloat((graphInset * 2))) / CGFloat(verticalSegments) * CGFloat(segment))
	}
}
