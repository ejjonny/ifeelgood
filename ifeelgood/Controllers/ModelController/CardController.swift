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
	/// Should be used for getting the last week / month / year of entries
	func entriesWith(graphViewStyle: GraphRangeOptions) -> [Entry] {
		switch graphViewStyle {
		case .allTime:
			guard let group = entriesGroupedBy(dateStyle: .all).last else { return [] }
			return group
		case .today:
			guard let group = entriesGroupedBy(dateStyle: .day).last else { return [] }
			return group
		case .thisWeek:
			guard let group = entriesGroupedBy(dateStyle: .week).last else { return [] }
			return group
		case .thisMonth:
			guard let group = entriesGroupedBy(dateStyle: .month).last else { return [] }
			return group
		case .thisYear:
			guard let group = entriesGroupedBy(dateStyle: .year).last else { return [] }
			return group
		}
	}
	
	/// Should be used for getting grouped statistics.
	func entriesWith(dateStyle: EntryDateStyles) -> [EntryStats] {
		var stats: [EntryStats] = []
		for group in entriesGroupedBy(dateStyle: dateStyle) {
			let totalRatings = group.map{ $0.rating }.reduce(0, +)
			let average = totalRatings / Double(group.count)
			var name = ""
			guard let date = group.first?.date else { print("Error compiling entries by date") ; return [] }
			switch dateStyle {
			case .all:
				name = date.asTimeSpecificString()
			case .day:
				name = date.asString()
			case .month:
				name = date.asMonthSpecificString()
			case .week:
				break
			case .year:
				break
			}
			stats.append(EntryStats(name: name, ratingCount: group.count, averageRating: average ))
		}
		return stats
	}
	
	func entriesGroupedBy(dateStyle: EntryDateStyles) -> [[Entry]] {
		guard let entries = activeCard.entries else { return [[]] }
		let calendar = Calendar.current
		let grouped: [DateComponents:[Entry]]
		switch dateStyle {
		case .all:
			grouped = Dictionary(grouping: entries.map{ $0 as! Entry }, by: {
				calendar.dateComponents([.second,.minute,.day,.month,.year], from: $0.date!)
			})
		case .day:
			grouped = Dictionary(grouping: entries.map{ $0 as! Entry }, by: {
				calendar.dateComponents([.day, .month, .year], from: $0.date!)
			})
		case .week:
			grouped = Dictionary(grouping: entries.map{ $0 as! Entry }, by: {
				calendar.dateComponents([.weekOfYear], from: $0.date!)
			})
		case .month:
			grouped = Dictionary(grouping: entries.map{ $0 as! Entry }, by: {
				calendar.dateComponents([.month, .year], from: $0.date!)
			})
		case .year:
			grouped = Dictionary(grouping: entries.map{ $0 as! Entry }, by: {
				calendar.dateComponents([.year], from: $0.date!)
			})
		}
		return grouped.map{ $0.value }.sorted(by: { (arrayOne, arrayTwo) -> Bool in
			guard let firstDate = arrayOne.first?.date,
				let secondDate = arrayTwo.first?.date else { print("Failed to sort") ; return true }
			return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
		})
	}
	
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

