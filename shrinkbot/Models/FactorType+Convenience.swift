//
//  FactorType+Convenience.swift
//  shrinkbot
//
//  Created by Ethan John on 2/1/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData

extension FactorType {
	@discardableResult
	convenience init(name: String, card: Card, moc: NSManagedObjectContext = CoreDataStack.context) {
		self.init(context: moc)
		self.name = name
		self.card = card
	}
}
