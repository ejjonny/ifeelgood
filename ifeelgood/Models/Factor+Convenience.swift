//
//  Factor+Convenience.swift
//  ifeelgood
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension Factor {
	@discardableResult
	convenience init(name: String, isActive: Bool = false, moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.name = name
		self.isActive = isActive
	}
}
