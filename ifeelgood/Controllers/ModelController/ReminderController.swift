//
//  ReminderController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

class ReminderController {
	
	static let shared = ReminderController()
	
	var reminders: [Reminder] = []
	
	var activeReminders: [Reminder] {
		return self.reminders.filter{ $0.isOn == true }
	}
	
	func createReminderWith(date: Date, frequency: Frequency, completion: @escaping (Bool) -> Void) {
		NotificationManager.setUpRecurringNotification(title: "How are you?", body: "Check in often to learn from your progress.", date: date, frequency: frequency) { (success) in
			if success {
				Reminder(isOn: true, timeOfDay: date, frequency: frequency)
				CoreDataManager.saveToPersistentStore()
				completion(true)
			} else {
				completion(false)
			}
		}
	}
	
	func toggle(reminder: Reminder) {
		reminder.isOn = !reminder.isOn
		CoreDataManager.saveToPersistentStore()
	}
	
	func update(reminder: Reminder, isOn: Bool, timeOfDay: Date, frequency: Frequency, completion: @escaping (Bool) -> Void) {
		reminder.isOn = isOn
		reminder.timeOfDay = timeOfDay
		reminder.frequency = frequency.rawValue
		CoreDataManager.saveToPersistentStore()
	}
	
	func delete(reminder: Reminder) {
		CoreDataStack.context.delete(reminder)
		CoreDataManager.saveToPersistentStore()
	}
}
