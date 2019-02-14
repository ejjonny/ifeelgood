//
//  GraphView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/14/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class GraphView: UIView {

	var path: UIBezierPath?
	
    override func draw(_ rect: CGRect) {
		guard let graphPath = self.path else { print("Path is nil - no graph drawn."); return }
		graphPath.lineWidth = 10.0
		graphPath.lineCapStyle = .round
		UIColor.black.setStroke()
		graphPath.stroke()
		graphPath.close()
    }
}
