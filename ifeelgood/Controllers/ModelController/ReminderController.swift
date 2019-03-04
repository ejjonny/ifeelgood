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
	
	private let title = "How are you?"
	private let body = "Check in often to learn from your progress."
	
	static let shared = ReminderController()
	
	var reminders: [Reminder] = []
	
	var activeReminders: [Reminder] {
		return self.reminders.filter{ $0.isOn == true }
	}
	
	func createReminderWith(date: Date, frequency: Frequency, completion: @escaping (Bool) -> Void) {
		let reminder = Reminder(isOn: true, timeOfDay: date, frequency: frequency)
		NotificationManager.setUpRecurringNotification(title: title, body: body, reminder: reminder) { (success) in
			if success {
				CoreDataManager.saveToPersistentStore()
				completion(true)
				return
			}
			self.delete(reminder: reminder)
			completion(false)
		}
	}
	
	func toggle(reminder: Reminder) {
		if reminder.isOn {
			NotificationManager.removeRecurringNotificationFor(reminder: reminder) { (success) in
				if success {
					reminder.isOn = false
					CoreDataManager.saveToPersistentStore()
					return
				}
				print("Reminder toggle off failed.")
			}
		} else if reminder.isOn == false {
			NotificationManager.setUpRecurringNotification(title: title, body: body, reminder: reminder) { (success) in
				if success {
					reminder.isOn = true
					CoreDataManager.saveToPersistentStore()
					return
				}
				print("Reminder toggle on failed.")
				return
			}
		}
	}
	
	func update(reminder: Reminder, isOn: Bool, timeOfDay: Date, frequency: Frequency, completion: @escaping (Bool) -> Void) {
		reminder.isOn = isOn
		reminder.timeOfDay = timeOfDay
		reminder.frequency = frequency.rawValue
		NotificationManager.removeRecurringNotificationFor(reminder: reminder) { (success) in
			if success {
				NotificationManager.setUpRecurringNotification(title: self.title, body: self.body, reminder: reminder, completion: { (success) in
					if success {
						completion(true)
					}
					completion(false)
				})
			}
			completion(false)
		}
		CoreDataManager.saveToPersistentStore()
	}
	
	func delete(reminder: Reminder) {
		CoreDataStack.context.delete(reminder)
		NotificationManager.removeRecurringNotificationFor(reminder: reminder) { (success) in
			
		}
		CoreDataManager.saveToPersistentStore()
	}
}
