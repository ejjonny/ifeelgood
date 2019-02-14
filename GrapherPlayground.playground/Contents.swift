//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class graphView: UIView {
	
	var graphLineColor = UIColor.black
	
	override func draw(_ rect: CGRect) {
		// Example data
		self.drawGraph(YValues: [ 1, 2, 0, 10 ], smoothing: 0.3)
	}
	
	/** Graph data relative to parent view.
	- Parameter YValues: The data points you want to graph.
	- Parameter smoothing: Controls the smoothing factor. This should be between 0.0 & 1.0
	*/
	func drawGraph(YValues: [CGFloat], smoothing: CGFloat) {
		// Init path
		let graphPath: UIBezierPath = UIBezierPath()
		
		// Calculate smoothing relative to segment width
		let smoothingRelativeToSegment = (self.bounds.width / CGFloat(YValues.count - 1)) * smoothing
		
		// Set initial value for loop to use in first iteration
		var pointZero = CGPoint(x: XRelativeTo(view: self, data: YValues, index: 0), y: YRelativeTo(view: self, value: YValues.first!, data: YValues))
		
		// Set origin of path
		graphPath.move(to: pointZero)
		
		// Loop through array and graph points
		for (index, YValue) in YValues.enumerated() {
			// Point that will be graphed
			let pointOne = CGPoint(x: XRelativeTo(view: self, data: YValues, index: index), y: YRelativeTo(view: self, value: YValue, data: YValues))
			// First and last index points will be graphed with different curves
			if index + 1 < YValues.count && index != 0 {
				graphPath.addCurve(to: pointOne, controlPoint1: CGPoint(x: pointZero.x + smoothingRelativeToSegment, y: pointZero.y), controlPoint2: CGPoint(x: pointOne.x - smoothingRelativeToSegment, y: pointOne.y))

			} else if index == 0 {
				graphPath.addLine(to: pointOne)
			} else {
				graphPath.addCurve(to: pointOne, controlPoint1: CGPoint(x: pointZero.x + smoothingRelativeToSegment, y: pointZero.y), controlPoint2: pointOne)
				graphPath.addLine(to: pointOne)
			}
			// Set the last point to the current point before next iteration
			pointZero = pointOne
		}
		graphPath.lineWidth = 10.0
		graphPath.lineCapStyle = .round
		graphLineColor.setStroke()
		graphPath.stroke()
		graphPath.close()
	}
	
	/** Calculates X coord based on number of datapoints & view width
	- Parameter view: The view who's width the points will be plotted relative to.
	- Parameter data: The array that is being plotted.
	- Parameter index: The index of the point who's X needs to be calculated.
	*/
	func XRelativeTo(view: UIView, data: [CGFloat], index: Int) -> CGFloat {
		return (view.bounds.width / CGFloat(data.count - 1)) * (CGFloat(index))
	}
	
	/** Calculates Y coord based on the max value & view height
	- Parameter view: The view who's height the points will be graphed relative to.
	- Parameter value: The Y value being plotted.
	- Parameter data: The data set being plotted.
	*/
	func YRelativeTo(view: UIView, value: CGFloat, data: [CGFloat]) -> CGFloat {
		return view.bounds.height - (view.bounds.height * (value / (data.max() ?? 0)))
	}
}


class MyViewController : UIViewController {
	override func loadView() {
		
		let view = graphView()
		view.backgroundColor = .white
		
		self.view = view
	}
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
