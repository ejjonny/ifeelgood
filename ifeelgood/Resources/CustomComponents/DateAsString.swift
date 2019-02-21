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
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: self)
	}
}
