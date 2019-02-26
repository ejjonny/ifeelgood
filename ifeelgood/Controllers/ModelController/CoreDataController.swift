//
//  CoreDataController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class CoreDataController {
	
	static let shared = CoreDataController()
	
	// MARK: - Save to persistent store
	func saveToPersistentStore() {
		do {
			try CoreDataStack.context.save()
			print("Saved")
		} catch {
			print("Unable to save to persistent store. \(error): \(error.localizedDescription)")
		}
	}
}
