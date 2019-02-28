//
//  ReminderController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

enum frequencyOptions: String {
	case daily = "daily"
	case everyOtherDay = "everyOtherDay"
	case weekly = "weekly"
}

class ReminderController {
	
	static let shared = ReminderController()
	
	var reminders: [Reminder] {
		let reminderRequest = NSFetchRequest<Reminder>(entityName: "Reminder")
		let predicate = NSPredicate(value: true)
		let dateSort = NSSortDescriptor(key: "timeOfDay", ascending: true)
		reminderRequest.sortDescriptors = [dateSort]
		reminderRequest.predicate = predicate
		var reminders = [Reminder]()
		do {
			reminders = try CoreDataStack.context.fetch(reminderRequest)
		} catch {
			print(error.localizedDescription, "Didn't find any reminders.")
		}
		return reminders
	}
	
	var activeReminders: [Reminder] {
		return self.reminders.filter{ $0.isOn == true }
	}
	
	func createReminder() {
		Reminder(isOn: true, timeOfDay: Date(), frequency: frequencyOptions.daily)
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
		CoreDataController.shared.saveToPersistentStore()
	}
}
