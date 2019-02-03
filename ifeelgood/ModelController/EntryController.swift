//
//  EntryController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
	
	// Singleton
	static var shared = EntryController()
	
	// MARK: - FetchResultsController
	let fetchResultsController: NSFetchedResultsController<Entry> = {
		let request = NSFetchRequest<Entry>(entityName: "Entry")
		let dateSort = NSSortDescriptor(key: "date", ascending: true)
		request.sortDescriptors = [dateSort]
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
	
	// MARK: - CUD
	func createEntryWith(mindRating: Double, bodyRating: Double) {
		Entry(mindRating: mindRating, bodyRating: bodyRating)
		saveToPersistentStore()
	}
	
	func updateEntry() {
		// Unused
		print("Update function not set up")
	}
	
	func delete(entry: Entry) {
		// Unused
		print("Delete function not set up")
	}
	
	// MARK: - Save to persistent store
	func saveToPersistentStore() {
		do {
			try CoreDataStack.context.save()
		} catch {
			print("Unable to save to persistent store. \(error): \(error.localizedDescription)")
		}
	}
	
	// MARK: - Load from persistent store on init
	init() {
		do {
			try fetchResultsController.performFetch()
		} catch {
			print("Unable to load entries: \(error): \(error.localizedDescription)")
		}
	}
}
