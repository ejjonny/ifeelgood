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
	
	var entryDateStyle: EntryDateStyles = .day
		
	// Singleton
	static var shared = CardController()
	
	var cards: [Card] = []
	
	var activeCardEntries: [Entry] {
		guard let entries = activeCard.entries?.array as? [Entry] else { print("There was an error with OrderedSet to Array conversion") ; return []}
		return entries
	}
	
	var activeCard: Card {
		
		let activeArray = cards.filter{ $0.isActive == true }
		
		// Make sure datasource has cards, if not make a default card.
		if cards.isEmpty {
			return createCard(named: "My New Card")
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
			CoreDataManager.saveToPersistentStore()
			
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
	
	func entriesWith(graphViewStyle: GraphViewStyles) -> [EntryStats] {
		// TODO: - Return a usable segment of Entry stats by relevant dateStyle (This will be graphed & shouldn't have too many x values ex. Jan, Feb, March)
		return []
	}
	
	/// Call on background thread to avoid stalling UI.
	func entriesWith(dateStyle: EntryDateStyles) -> [EntryStats] {
		guard let entries = self.activeCard.entries else { return [] }
		let calendar = Calendar.current
		var stats: [EntryStats] = []
		var lastEntry: Entry?
		var entryGroup: [Entry] = []
		
		for entry in entries {
			switch dateStyle {
			case .all:
				stats = entries.compactMap{ $0 as? Entry }.map{ EntryStats(name: $0.date?.asString() ?? "date", ratingCount: 1, averageRating: $0.rating) }
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
		CoreDataManager.saveToPersistentStore()
		return card
	}
	
	func renameActiveCard(withName name: String) {
		self.activeCard.name = name
		CoreDataManager.saveToPersistentStore()
	}
	
	func deleteActiveCard(completion: ((Bool) -> Void)?) {
		CoreDataStack.context.delete(self.activeCard)
		CoreDataManager.saveToPersistentStore()
		if let completion = completion {
			completion(true)
		}
	}
	
	func setActive(card: Card) {
		// If there is currently an active card deactivate it.
		for card in cards {
			if card.isActive {
				card.isActive = false
			}
		}
		card.isActive = true
		CoreDataManager.saveToPersistentStore()
	}
	
	// MARK: - Factor control
	func createFactorType(withName name: String) {
		guard let factorTypeCount = activeCard.factorTypes?.count else { print("Card does not have any factor types."); return }
		if factorTypeCount < 3 {
			FactorType(name: name, card: activeCard)
		} else {
			print("ERROR: Tried to save a factor when all factors on active card were full. Factor was not saved.")
		}
		CoreDataManager.saveToPersistentStore()
	}
	
	func renameFactorType(_ factorType: FactorType, withName name: String) {
		factorType.name = name
		CoreDataManager.saveToPersistentStore()
	}
	
	func deleteFactorType(_ factorType: FactorType) {
		CoreDataStack.context.delete(factorType)
		CoreDataManager.saveToPersistentStore()
	}
	
	func createFactorMark(ofType type: FactorType, onEntry entry: Entry) {
		guard let name = type.name else { print("FactorType name was nil. Entry not created"); return }
		FactorMark(name: name, entry: entry)
		CoreDataManager.saveToPersistentStore()
	}
	
	func deleteFactorMark(named: String, fromEntries: [Entry]) {
		// TODO: - Delete factor marks here
	}
	
	// MARK: - Entry control
	func createEntry(ofRating rating: Double, factorMarks: [FactorType]) {
		let entry = Entry(rating: rating, onCard: activeCard)
		for mark in factorMarks {
			guard let name = mark.name else { print("Name on factor type was nil. Mark not created."); return }
			FactorMark(name: name, entry: entry)
		}
		CoreDataManager.saveToPersistentStore()
	}
	
	func delete(entry: Entry) {
		CoreDataStack.context.delete(entry)
		CoreDataManager.saveToPersistentStore()
	}
}

