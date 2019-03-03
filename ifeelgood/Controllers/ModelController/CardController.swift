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
	
	var entryDateStyle: entryDateStyles = .day
		
	// Singleton
	static var shared = CardController()
	
	var cards: [Card] = [] {
		didSet {
			print(cards.count)
		}
	}
	
	var activeCard: Card {
		
		let activeArray = cards.filter{ $0.isActive == true }
		
		// Make sure datasource has cards, if not make a default card.
		if cards.isEmpty {
			return createCard(named: "My new card")
		}

		if activeArray.count > 1 || activeArray.count == 0 {
			// Deactivate all & set last to active and return it if there are more than one active cards.
			if activeArray.count == 0 {
				print("No active cards")
			} else if activeArray.count > 1 {
				print("Error: Multiple active cards")
			}
			for card in activeArray {
				card.isActive = false
			}
			if let last = cards.last {
				last.isActive = true
				return last
			}
			CoreDataController.shared.saveToPersistentStore()
		} else if activeArray.count == 1, let first = activeArray.first {
			// If there is one active card return it. All is well.
			return first
		}
		// Last resort
		print("Error: active card computed property should cover all cases.")
		return createCard(named: "My new card")
	}
	
	var activeCardFactorTypes: [FactorType] {
		guard let array = activeCard.factorTypes?.array as? [FactorType] else { print("Unable to cast set as factor types."); return []}
		return array
	}
	
	
	func entriesByDateStyle() -> [EntryStats] {
		
		guard let entries = self.activeCard.entries else { return [] }
		let calendar = Calendar.current
		var stats: [EntryStats] = []
		var lastEntry: Entry?
		var entryGroup: [Entry] = []
		
		for entry in entries {
			switch self.entryDateStyle {
			case .all:
				break
			case .day:
				guard let entryObject = entry as? Entry else { print("Found nil while unwrapping entry.");return [] }
				guard let entryObjectDate = entryObject.date else { print("Found nil while unwrapping entry date."); return []}
				let entryDateComponents = calendar.dateComponents([.day, .month, .year], from: entryObjectDate)
				
				// If it's not the first one
				if let last = lastEntry {
					guard let lastEntryDate = last.date else { print("Found nil while unwrapping an entry's date."); return []}
					let lastEntryComponents = calendar.dateComponents([.day, .month, .year], from: lastEntryDate)
					guard let lastEntryDay = lastEntryComponents.day,
						let lastEntryMonth = lastEntryComponents.month,
						let lastEntryYear = lastEntryComponents.year,
						let entryDay = entryDateComponents.day,
						let entryMonth = entryDateComponents.month,
						let entryYear = entryDateComponents.year else { print("Found nil while unwrapping entry date components."); return [] }
					// New group
					if entryDay > lastEntryDay || entryMonth != lastEntryMonth || entryYear != lastEntryYear && entries.index(of: entry) != entries.count - 1 {
						var averageRating: Double?
						for entryObject in entryGroup {
							guard averageRating != nil else { averageRating = entryGroup.first?.rating; continue }
							averageRating = (averageRating! + entryObject.rating) / 2
						}
						guard let average = averageRating else { print("Found nil while unwrapping a rating."); return []}
						stats.append(EntryStats(name: "\(lastEntry?.date?.asString() ?? "Date")", ratingCount: entryGroup.count, averageRating: average))
						entryGroup = []
						averageRating = 0
					}
				}
				// If first
				entryGroup.append(entryObject)
				lastEntry = entryObject
				// If last
				if entries.index(of: entry) == entries.count - 1 {
					var averageRating: Double?
					for entryObject in entryGroup {
						guard averageRating != nil else { averageRating = entryGroup.first?.rating; continue }
						averageRating = (averageRating! + entryObject.rating) / 2
					}
					guard let average = averageRating else { print("Found nil while unwrapping a rating."); return []}
					stats.append(EntryStats(name: "\(lastEntry?.date?.asString() ?? "Date")", ratingCount: entryGroup.count, averageRating: average))
				}
			case .week:
				break
			case .month:
				break
			case .year:
				break
			}
		}
		return stats
	}
	
	func formatDateAsString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")
		return dateFormatter.string(from: date)
	}
	
	// MARK: - Card control
	func createCard(named name: String) -> Card {
		let card = Card(name: name)
		self.setActive(card: card)
		CoreDataController.shared.saveToPersistentStore()
		CoreDataController.shared.loadFromPersistentStore()
		return card
	}
	
	func renameActiveCard(withName name: String) {
		self.activeCard.name = name
		CoreDataController.shared.saveToPersistentStore()
	}
	
	func deleteActiveCard() {
		CoreDataStack.context.delete(self.activeCard)
		guard let index = CardController.shared.cards.index(of: activeCard) else { print("Error deleting active card") ; return }
		CardController.shared.cards.remove(at: index)
		CoreDataController.shared.saveToPersistentStore()
	}
	
	func setActive(card: Card) {
		// If there is currently an active card deactivate it.
		for card in cards {
			if card.isActive {
				card.isActive = false
			}
		}
		card.isActive = true
		CoreDataController.shared.saveToPersistentStore()
	}
	
	// MARK: - Factor control
	func createFactorType(withName name: String) {
		guard let factorTypeCount = activeCard.factorTypes?.count else { print("Card does not have any factor types."); return }
		if factorTypeCount < 3 {
			FactorType(name: name, card: activeCard)
		} else {
			print("ERROR: Tried to save a factor when all factors on active card were full. Factor was not saved.")
		}
		CoreDataController.shared.saveToPersistentStore()
	}
	
	func replaceFactorType(_ factorType: FactorType, withName name: String) {
		CoreDataStack.context.delete(factorType)
		createFactorType(withName: name)
		CoreDataController.shared.saveToPersistentStore()
		CoreDataController.shared.loadFromPersistentStore()
	}
	
	func deleteFactorType(_ factorType: FactorType) {
		CoreDataStack.context.delete(factorType)
		CoreDataController.shared.saveToPersistentStore()
		CoreDataController.shared.loadFromPersistentStore()
	}
	
	func createFactorMark(ofType type: FactorType, onEntry entry: Entry) {
		guard let name = type.name else { print("FactorType name was nil. Entry not created"); return }
		FactorMark(name: name, entry: entry)
		CoreDataController.shared.saveToPersistentStore()
		CoreDataController.shared.loadFromPersistentStore()
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
		CoreDataController.shared.saveToPersistentStore()
		CoreDataController.shared.loadFromPersistentStore()
	}
}

