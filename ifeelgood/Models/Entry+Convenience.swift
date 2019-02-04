//
//  Entry+Convenience.swift
//  ifeelgood
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
	@discardableResult
	convenience init(mindRating: Double, date: Date = Date(), uuid: UUID = UUID(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.mindRating = mindRating
		self.date = Date()
		self.uuid = UUID()
	}
}
