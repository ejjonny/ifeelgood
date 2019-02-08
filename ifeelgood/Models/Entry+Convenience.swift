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
	convenience init(rating: Double, inCard card: Card, date: Date = Date(), uuid: UUID = UUID(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.rating = rating
		self.inCard = card
		self.date = Date()
		self.uuid = UUID()
	}
}
