//
//  CardController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/7/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation
import CoreData


class CardController {
	
	// Singleton
	static var shared = CardController()
	
	var activeCard: Card? {
		let cardRequest = NSFetchRequest<Card>(entityName: "Card")
		let predicate = NSPredicate(format: "isActive = true")
		let dateSort = NSSortDescriptor(key: "startDate", ascending: true)
		cardRequest.sortDescriptors = [dateSort]
		cardRequest.predicate = predicate
		do {
			if try CoreDataStack.context.fetch(cardRequest).indices.contains(0) {
				return try CoreDataStack.context.fetch(cardRequest)[0]
			} else {
				return nil
			}
		} catch {
			print(error.localizedDescription, "There are no cards")
			return nil
		}
	}
	
	var cards: [Card] {
		do {
			try fetchResultsController.performFetch()
			guard let results = fetchResultsController.fetchedObjects else { print("There were no objects fetched"); return []}
			return results
		} catch {
			print(error, error.localizedDescription)
			return []
		}
	}
	
	// MARK: - Card functions
	func createDefaultCard() {
		createCard(named: "My new card")
	}
	
	func createCard(named name: String){
		let card = Card(name: name)
		createFactor(withName: "An influence to track")
		self.setActive(card: card)
		saveToPersistentStore()
	}
	
	func renameActiveCard(withName name: String) {
		self.activeCard?.name = name
		saveToPersistentStore()
	}
	
	func deleteActiveCard() {
		CoreDataStack.context.delete(self.activeCard!)
		saveToPersistentStore()
	}
	
	func setActive(card: Card) {
		// If there is currently an active card deactivate it.
		if let active = activeCard {
			active.isActive = false
		}
		card.isActive = true
		saveToPersistentStore()
	}
	
	// MARK: - Factor functions
	func createFactor(withName name: String) {
		let factor = Factor(name: name)
		guard let card = self.activeCard else { print("ERROR: No active card"); return }
		if card.factorX == nil {
			card.factorX = factor
		} else if card.factorY == nil {
			card.factorY = factor
		} else if card.factorZ == nil {
			card.factorZ = factor
		} else {
			print("ERROR: Tried to save a factor when all factors on active card were full. Factor not saved.")
		}
		saveToPersistentStore()
	}
	
	func replaceFactor(_ factor: Factor, withName name: String, onCard card: Card) {
		CoreDataStack.context.delete(factor)
		createFactor(withName: name)
		saveToPersistentStore()
	}
	
	// MARK: - Entry functions
	func createEntry(ofRating rating: Double, onCard card: Card, X: Bool, Y: Bool, Z: Bool) {
		Entry(rating: rating, inCard: card, XActive: X, YActive: Y, ZActive: Z)
		saveToPersistentStore()
	}
	
	// MARK: - FetchResultsController
	let fetchResultsController: NSFetchedResultsController<Card> = {
		let request = NSFetchRequest<Card>(entityName: "Card")
		let dateSort = NSSortDescriptor(key: "startDate", ascending: true)
		request.sortDescriptors = [dateSort]
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
	
	// MARK: - Load from persistent store on init
	init() {
		do {
			try fetchResultsController.performFetch()
		} catch {
			print("Unable to load entries: \(error): \(error.localizedDescription)")
		}
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
}

