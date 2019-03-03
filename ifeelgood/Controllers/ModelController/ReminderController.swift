//
//  ReminderController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

struct frequency {
	static let options = ["daily", "everyOtherDay", "weekly"]
}

class ReminderController {
	
	static let shared = ReminderController()
	
	var reminders: [Reminder] = []
	
	var activeReminders: [Reminder] {
		return self.reminders.filter{ $0.isOn == true }
	}
	
	func createReminder() {
		let reminder = Reminder(isOn: true, timeOfDay: Date(), frequency: frequency.options[0])
		reminders.append(reminder)
		CoreDataController.shared.saveToPersistentStore()
	}
	func toggle(reminder: Reminder) {
		reminder.isOn = !reminder.isOn
		CoreDataController.shared.saveToPersistentStore()
	}
	func update(reminder: Reminder, isOn: Bool, timeOfDay: Date, frequency: String) {
		reminder.isOn = isOn
		reminder.timeOfDay = timeOfDay
		reminder.frequency = frequency
		CoreDataController.shared.saveToPersistentStore()
	}
	func delete(reminder: Reminder) {
		CoreDataStack.context.delete(reminder)
		guard let index = ReminderController.shared.reminders.index(of: reminder) else { print("Error deleting reminder") ; return }
		ReminderController.shared.reminders.remove(at: index)
		CoreDataController.shared.saveToPersistentStore()
	}
}
