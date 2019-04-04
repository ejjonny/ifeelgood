//
//  EntryStats.swift
//  ifeelgood
//
//  Created by Ethan John on 2/19/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class EntryStats {
	let name: String
	let ratingCount: Int
	let averageRating: Double
	
	init(name: String, ratingCount: Int, averageRating: Double) {
		self.name = name
		self.ratingCount = ratingCount
		self.averageRating = averageRating
	}
}

extension EntryStats: Equatable {
	
	static func == (lhs: EntryStats, rhs: EntryStats) -> Bool {
		return lhs.name == rhs.name && lhs.averageRating == rhs.averageRating && lhs.ratingCount == rhs.ratingCount
	}
}
