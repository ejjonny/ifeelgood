//
//  CoreDataManager.swift
//  shrinkbot
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
	
	// MARK: - Persistence
	static func saveToPersistentStore(completion: ((Bool) -> Void)? = { success in
		
		if (success) {
			CoreDataManager.loadFromPersistentStore()
		} else {
			print("Error saving")
		}}) {
		do {
			try CoreDataStack.context.save()
			if let comp = completion {
				comp(true)
			}
		} catch {
			print("Unable to save to persistent store. \(error): \(error.localizedDescription)")
			if let comp = completion {
				comp(false)
			}
		}
	}
	
	static func loadFromPersistentStore() {
		
		// MARK: Reminder fetch controller
		do {
			try reminderFetchResultsController.performFetch()
			guard let reminderResults = reminderFetchResultsController.fetchedObjects else {
				print("No reminders fetched")
				ReminderController.shared.reminders = []
				return
			}
			ReminderController.shared.reminders = reminderResults
		} catch {
			print("Error fetching reminders:", error, error.localizedDescription)
			ReminderController.shared.reminders = []
		}
		
		// MARK: Card fetch controller
		do {
			try cardFetchResultsController.performFetch()
			guard let cardResults = cardFetchResultsController.fetchedObjects else {
				print("No cards fetched")
				// If nothing was fetched set the array as empty.
				CardController.shared.cards = []
				return
			}
			CardController.shared.cards = cardResults
			NotificationCenter.default.post(Notification(name: Notification.Name("loadedFromCoreData")))
		} catch {
			print("Error fetching cards:", error, error.localizedDescription)
			// If error set array as empty.
			CardController.shared.cards = []
		}
	}
	
	// MARK: FetchResultsControllers
	private static let cardFetchResultsController: NSFetchedResultsController<Card> = {
		let request = NSFetchRequest<Card>(entityName: "Card")
		let dateSort = NSSortDescriptor(key: "startDate", ascending: true)
		request.sortDescriptors = [dateSort]
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
	
	private static let reminderFetchResultsController: NSFetchedResultsController<Reminder> = {
		let request = NSFetchRequest<Reminder>(entityName: "Reminder")
		let predicate = NSPredicate(value: true)
		let dateSort = NSSortDescriptor(key: "timeOfDay", ascending: true)
		request.sortDescriptors = [dateSort]
		request.predicate = predicate
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
}
