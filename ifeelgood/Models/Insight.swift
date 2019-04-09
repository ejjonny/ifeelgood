//
//  Insight.swift
//  ifeelgood
//
//  Created by Ethan John on 3/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class Insight {
	
	var title: String
	var description: String
	var score: Double
	
	init(title: String, description: String, score: Double) {
		self.title = title
		self.description = description
		self.score = score
	}
}

class IntervalAnalysis {
	var avgRating: Double
	var factorInvolved: FactorType
	var intervalEntries: [Entry]
	var factorPresent: Bool
	var score: Double
	
	init(avgRating: Double, forFactor: FactorType, intervalEntries: [Entry], factorPresent: Bool, reliability: Double) {
		self.avgRating = avgRating
		self.factorInvolved = forFactor
		self.intervalEntries = intervalEntries
		self.factorPresent = factorPresent
		self.score = reliability
	}
}
