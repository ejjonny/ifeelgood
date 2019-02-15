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
	
	// MARK: - Load from persistent store on init
	init() {
		do {
			try fetchResultsController.performFetch()
		} catch {
			print("Unable to load data: \(error): \(error.localizedDescription)")
		}
	}
	
	// Singleton
	static var shared = CardController()
	
	var activeCard: Card {
		let cardRequest = NSFetchRequest<Card>(entityName: "Card")
		let predicate = NSPredicate(format: "isActive = true")
		let dateSort = NSSortDescriptor(key: "startDate", ascending: true)
		cardRequest.sortDescriptors = [dateSort]
		cardRequest.predicate = predicate
		var activeCards = [Card]()
		do {
			activeCards = try CoreDataStack.context.fetch(cardRequest)
		} catch {
			print(error.localizedDescription, "Didn't find a card marked as active.")
		}
		// Check the count of active cards.
		if activeCards.count > 1 {
			print("There are multiple cards marked as active. This shouldn't print")
		}
		// If we get a card back from fetch return it
		if activeCards.indices.contains(0) {
			return activeCards[0]
		}
		// Activate the last card in the stack
		if let lastCard = cards.last {
			lastCard.isActive = true
			return lastCard
		}
		// Last resort make a default card
		return Card(name: "My New Card", isActive: true)
	}
	
	var activeCardFactorTypes: [FactorType] {
		guard let array = activeCard.factorTypes?.array as? [FactorType] else { print("Unable to cast set as factor types."); return []}
		return array
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
	func createCard(named name: String){
		let card = Card(name: name)
		self.setActive(card: card)
		saveToPersistentStore()
	}
	
	func renameActiveCard(withName name: String) {
		self.activeCard.name = name
		saveToPersistentStore()
	}
	
	func deleteActiveCard() {
		CoreDataStack.context.delete(self.activeCard)
		saveToPersistentStore()
	}
	
	func setActive(card: Card) {
		// If there is currently an active card deactivate it.
		activeCard.isActive = false
		card.isActive = true
		saveToPersistentStore()
	}
	
	// MARK: - Factor functions
	func createFactorType(withName name: String) {
		guard let factorTypeCount = activeCard.factorTypes?.count else { print("Card's factor types were nil. Factor not created."); return }
		if factorTypeCount < 3 {
			FactorType(name: name, card: activeCard)
		} else {
			print("ERROR: Tried to save a factor when all factors on active card were full. Factor was not saved.")
		}
		saveToPersistentStore()
	}
	
	func replaceFactorType(_ factorType: FactorType, withName name: String) {
		CoreDataStack.context.delete(factorType)
		createFactorType(withName: name)
		saveToPersistentStore()
	}
	
	func deleteFactorType(_ factorType: FactorType) {
		CoreDataStack.context.delete(factorType)
		saveToPersistentStore()
	}
	
	func createFactorMark(ofType type: FactorType, onEntry entry: Entry) {
		guard let name = type.name else { print("FactorType name was nil. Entry not created"); return }
		FactorMark(name: name, entry: entry)
		saveToPersistentStore()
	}
	
	func deleteFactorMark(named: String, fromEntries: [Entry]) {
		// TODO: - Delete factor marks here
	}
	
	// MARK: - Entry functions
	func createEntry(ofRating rating: Double, factorMarks: [FactorType]) {
		let entry = Entry(rating: rating, onCard: activeCard)
		for mark in factorMarks {
			guard let name = mark.name else { print("Name on factor type was nil. Mark not created."); return }
			FactorMark(name: name, entry: entry)
		}
		saveToPersistentStore()
	}
	
	// MARK: - FetchResultsController
	let fetchResultsController: NSFetchedResultsController<Card> = {
		let request = NSFetchRequest<Card>(entityName: "Card")
		let dateSort = NSSortDescriptor(key: "startDate", ascending: true)
		request.sortDescriptors = [dateSort]
		return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
	}()
	
	// MARK: - Save to persistent store
	func saveToPersistentStore() {
		print(" There are \(cards.count) cards.")
		do {
			try CoreDataStack.context.save()
			print("Saved")
		} catch {
			print("Unable to save to persistent store. \(error): \(error.localizedDescription)")
		}
	}
}

