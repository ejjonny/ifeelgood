//
//  Reminder+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Reminder {
	@discardableResult
	convenience init(isOn: Bool, timeOfDay: Date, uuid: UUID = UUID(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.isOn = isOn
		self.timeOfDay = timeOfDay
		self.uuid = uuid
	}
}
