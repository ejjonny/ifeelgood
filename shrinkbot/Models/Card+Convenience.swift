//
//  Card+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/7/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Card {
	@discardableResult
	convenience init(name: String, isActive: Bool = false, factorTypes: NSOrderedSet = NSOrderedSet(), entries: NSOrderedSet = NSOrderedSet(), uuid: UUID = UUID(), startDate: Date = Date(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.name = name
		self.isActive = isActive
		self.factorTypes = factorTypes
		self.entries = entries
		self.uuid = uuid
		self.startDate = startDate
	}
}
