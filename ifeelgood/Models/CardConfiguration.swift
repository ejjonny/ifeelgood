//
//  CardConfiguration.swift
//  ifeelgood
//
//  Created by Ethan John on 4/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class CardConfiguration {
	var name: String
	var activeRating: Int?
	var factorsExpanded: Bool
	var factors: [(FactorType, Bool)]
	
	init(name: String, activeRating: Int? = nil, factorsExpanded: Bool = false, factors: [(FactorType, Bool)]) {
		self.name = name
		self.factorsExpanded = factorsExpanded
		self.factors = factors
		self.activeRating = activeRating
	}
}
