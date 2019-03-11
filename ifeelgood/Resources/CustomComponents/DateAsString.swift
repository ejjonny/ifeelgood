//
//  DateAsString.swift
//  ifeelgood
//
//  Created by Ethan John on 2/17/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

extension Date {
	
	func asString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM d', at 'h:mm a"
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
	
	func asTimeSpecificString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
	
	func asMonthSpecificString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM yyyy"
		return formatter.string(from: self)
	}
	
	func asYearSpecificString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy"
		return formatter.string(from: self)
	}
	
	func weekSpecific() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "M/d"
		return formatter.string(from: self)
	}
	
	func asTime() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .none
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
}
