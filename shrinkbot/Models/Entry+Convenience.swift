//
//  Entry+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
	@discardableResult
	convenience init(rating: Double, onCard card: Card, factorMarks: NSOrderedSet = NSOrderedSet(), date: Date = Date(), uuid: UUID = UUID(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.rating = rating
		self.onCard = card
		self.factorMarks = factorMarks
		self.date = Date()
		self.uuid = UUID()
	}
}
