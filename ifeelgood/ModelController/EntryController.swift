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
	
//	var entries: [Entry] {
//		do {
//			try fetchResultsController.performFetch()
//		} catch {
//			print(error, error.localizedDescription)
//		}
//		guard let results = fetchResultsController.fetchedObjects else { print("There was a problem fetching results"); return []}
//		return results
	//	}
	
	var entries = [ Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 100)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 360180)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 459720)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 87420)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 484500)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 489780)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 71880)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 45900)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 42480)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 380040)),
					Entry(mindRating: 1.0, date: Date(timeIntervalSinceNow: 472320))
	]
	
	// MARK: - FetchResultsController
	let fetchResultsController: NSFetchedResultsController<Entry> = {
		let request = NSFetchRequest<Entry>(entityName: "Entry")
		let dateSort = NSSortDescriptor(key: "date", ascending: true)
		request.sortDescriptors = [dateSort]
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
	
	// MARK: - CUD
	func createEntryWith(mindRating: Double){
		Entry(mindRating: mindRating)
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
			print("Saved")
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
