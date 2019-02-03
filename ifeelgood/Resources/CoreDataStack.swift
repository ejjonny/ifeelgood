//
//  CoreDataStack.swift
//  ifeelgood
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
	
	static let container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "ifeelgood")
		container.loadPersistentStores() { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	static var context: NSManagedObjectContext { return container.viewContext }
}
