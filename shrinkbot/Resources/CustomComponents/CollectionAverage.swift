//
//  CollectionAverage.swift
//  shrinkbot
//
//  Created by Ethan John on 4/4/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

extension Collection where Element: Numeric {
	/// Returns the total sum of all elements in array
	var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
	var average: Double {
		return isEmpty ? 0 : Double(total) / Double(count)
	}
}

extension Collection where Element: BinaryFloatingPoint {
	var average: Element {
		return isEmpty ? 0 : total / Element(count)
	}
}
