//
//  Card+Convenience.swift
//  ifeelgood
//
//  Created by Ethan John on 2/7/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Card {
	@discardableResult
	convenience init(name: String, isActive: Bool = false, uuid: UUID = UUID(), startDate: Date = Date(), moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.name = name
		self.isActive = isActive
	}
}
