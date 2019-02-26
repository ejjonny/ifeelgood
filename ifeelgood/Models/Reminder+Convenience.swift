//
//  Reminder+Convenience.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Reminder {
	@discardableResult
	convenience init(isOn: Bool, timeOfDay: Date, frequency: frequencyOptions, moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.isOn = isOn
		self.timeOfDay = timeOfDay
		self.frequency = frequency.rawValue
	}
}
