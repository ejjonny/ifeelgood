//
//  GraphFunction.swift
//  ifeelgood
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension MainViewController {
	/** Graph data relative to parent view. Stroke width above 10 may cause cutoff.
	- Parameter YValues: The data points you want to graph.
	- Parameter smoothing: Controls the smoothing factor. This should be between 0.0 & 1.0
	*/
	func bezierWithValues(onView view: UIView, YValues: [CGFloat], smoothing: CGFloat, inset: CGFloat) -> UIBezierPath {
		// Init path
		let graphPath: UIBezierPath = UIBezierPath()
		
		// Calculate smoothing relative to segment width
		let smoothingRelativeToSegment = (view.frame.width / CGFloat(YValues.count - 1)) * smoothing
		
		// Set initial value for loop to use in first iteration
		var pointZero = CGPoint(x: XRelativeTo(view: view, data: YValues, index: 0, inset: inset), y: YRelativeTo(view: view, value: YValues[0], data: YValues, inset: inset))
		
		// Set origin of path
		graphPath.move(to: pointZero)
		
		// Loop through array and graph points
		for (index, YValue) in YValues.enumerated() {
			// Point that will be graphed
			let pointOne = CGPoint(x: XRelativeTo(view: view, data: YValues, index: index, inset: inset), y: YRelativeTo(view: view, value: YValue, data: YValues, inset: inset))
			// First and last index points will be graphed with different curves
			if index + 1 < YValues.count && index != 0 {
				// If not last & not first
				graphPath.addCurve(to: pointOne, controlPoint1: CGPoint(x: pointZero.x + smoothingRelativeToSegment, y: pointZero.y), controlPoint2: CGPoint(x: pointOne.x - smoothingRelativeToSegment, y: pointOne.y))
			} else if index == 0 {
				// If first
				graphPath.addLine(to: pointOne)
			} else {
				// If last
				graphPath.addCurve(to: pointOne, controlPoint1: CGPoint(x: pointZero.x + smoothingRelativeToSegment, y: pointZero.y), controlPoint2: pointOne)
				graphPath.addLine(to: pointOne)
			}
			// Set the previous point to the current point before next iteration
			pointZero = pointOne
		}
		graphPath.lineWidth = 10.0
		graphPath.lineCapStyle = .round
		UIColor.black.setStroke()
		graphPath.stroke()
		return graphPath
	}
	
	/** Calculates X coord based on number of datapoints & view width
	- Parameter rect: The rect who's width the points will be plotted relative to.
	- Parameter data: The array that is being plotted.
	- Parameter index: The index of the point who's X needs to be calculated.
	*/
	func XRelativeTo(view: UIView, data: [CGFloat], index: Int, inset: CGFloat) -> CGFloat {
		// Width (minus stroke to avoid cutoff) divided by points in data and multiplied by the index of the point being plotted. Values adjusted by 10 to center
		return ((view.bounds.width - (inset * 2)) / CGFloat(data.count - 1)) * (CGFloat(index)) + inset
	}
	
	/** Calculates Y coord based on the max value & view height
	- Parameter rect: The rect who's height the points will be graphed relative to.
	- Parameter value: The Y value being plotted.
	- Parameter data: The data set being plotted.
	*/
	func YRelativeTo(view: UIView, value: CGFloat, data: [CGFloat], inset: CGFloat) -> CGFloat {
		// Proportion of value to max of data is applied to rect height minus stroke width to avoid cutoff on the edges. Values are adjusted by 10 to center points.
		return (view.bounds.height - ((view.bounds.height - (inset * 2)) * (value / (data.max() ?? 0)))) - inset
	}
}
