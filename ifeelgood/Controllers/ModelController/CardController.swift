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
	
//	func assignTypes() {
//		activeCardEntries.forEach { (entry) in
//			var marks = [Any]()
//			for mark in entry.factorMarks! {
//				marks.append(mark)
//			}
//			for mark in marks {
//				let mark2 = mark as! FactorMark
//				print("Checking mark name", mark2.name, mark2.type)
//				switch mark2.name {
//				case "Nic":
//					mark2.type = activeCardFactorTypes.filter{ $0.name == "Nic" }.first!
//				case "Alcohol":
//					mark2.type = activeCardFactorTypes.filter{ $0.name == "Alcohol" }.first!
//				case "Bad Sleep":
//					mark2.type = activeCardFactorTypes.filter{ $0.name == "Bad Sleep" }.first!
//				default:
//					fatalError()
//				}
//			}
//			CoreDataManager.saveToPersistentStore()
//		}
//	}

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
		FactorMark(name: name, entry: entry, type: type)
		CoreDataManager.saveToPersistentStore()
	}
	
	// MARK: - Entry control
	/// Should be used for getting the last day / week / month / year of entry statistics
	func entriesWith(graphViewStyle: GraphRangeOptions) -> [EntryStats] {
		var stats: [EntryStats] = []
		var grouped: [[Entry]] = []
		var name: String = ""
		var dateFormat: (Date) -> () -> String = Date.asString
		switch graphViewStyle {
		case .allTime:
			let filtered = getRecentEntriesIn(interval: .all)
			grouped = getEntries(entries: filtered, groupedBy: .day)
			dateFormat = Date.asGenericUseString
		case .thisMonth:
			let filtered = getRecentEntriesIn(interval: .month)
			grouped = getEntries(entries: filtered, groupedBy: .day)
			dateFormat = Date.asMonthSpecificString
		case .thisWeek:
			let filtered = getRecentEntriesIn(interval: .week)
			grouped = getEntries(entries: filtered, groupedBy: .day)
			dateFormat = Date.asWeekSpecificString
		case .thisYear:
			let filtered = getRecentEntriesIn(interval: .year)
			grouped = getEntries(entries: filtered, groupedBy: .month)
			dateFormat = Date.asYearSpecificString
		case .today:
			let filtered = getRecentEntriesIn(interval: .day)
			grouped = getEntries(entries: filtered, groupedBy: .all)
			dateFormat = Date.asDaySpecificString
		}
		for group in grouped {
			if let date = group.first?.date {
				name = dateFormat(date)()
			}
			var ratings = [Double]()
			var markTypes = [FactorType]()
			group.forEach{
				ratings.append($0.rating)
				let marksArray = $0.factorMarks?.array as! [FactorMark]
				for mark in marksArray {
					guard let type = mark.type,
						!markTypes.contains(type) else { continue }
					markTypes.append(type)
				}
			}
			let stat = EntryStats(name: name, ratingCount: group.count, averageRating: group.map{ $0.rating }.average, factorTypes: markTypes)
			// This filters out entries saved with only a factor & no rating so that data isn't skewed.
			if stat.averageRating != 0 {
				stats.append(stat)
			}
		}
		return stats
	}
	
	/// Should be used for getting grouped statistics.
	func entriesWith(dateStyle: EntryDateStyles) -> [EntryStats] {
		var stats: [EntryStats] = []
		for group in getEntries(groupedBy: dateStyle) {
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
			stats.append(EntryStats(name: name, ratingCount: group.count, averageRating: average, factorTypes: []))
		}
		return stats
	}
	
	/// For getting entries grouped by an interval relative to current date
	/// Ex. Last 24 hours for example would need to be grouped relative to current date so that grouping at 12:01am will still include a full day rather than just the calendar day that started at 12am
	func entriesGroupedByInterval(dateStyle: EntryDateStyles) -> [[Entry]] {
		guard let entrySet = activeCard.entries else { return [[]] }
		let entries = entrySet.compactMap{ $0 as? Entry}
		var grouped: [Date :[Entry]] = [:]
		switch dateStyle {
		case .all:
			return [entries]
		case .day:
			grouped = group(entries: entries, byInterval: day)
		case .week:
			grouped = group(entries: entries, byInterval: week)
		case .month:
			grouped = group(entries: entries, byInterval: month)
		case .year:
			grouped = group(entries: entries, byInterval: year)
		}
		return grouped.map{ $0.value }.sorted(by: { (arrayOne, arrayTwo) -> Bool in
			guard let firstDate = arrayOne.first?.date,
				let secondDate = arrayTwo.first?.date else { print("Failed to sort") ; return true }
			return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
		})
	}

	private func group(entries: [Entry], byInterval interval: TimeInterval) -> [Date: [Entry]]{
		var grouped: [Date: [Entry]] = [:]
		let reversed = Array(entries.reversed())
		guard let firstObject = reversed.first,
			var firstDateInGroup = firstObject.date else { print("First Obj didn't exist or didn't have a date when grouping") ; return [:] }
		for i in reversed.indices {
			guard let date = reversed[i].date else { print("An entry was missing a date") ; return [:] }
			if grouped[firstDateInGroup] != nil, abs(date.timeIntervalSince(firstDateInGroup)) <= interval {
				grouped[firstDateInGroup]!.append(reversed[i])
			} else {
				firstDateInGroup = date
				grouped[firstDateInGroup] = [reversed[i]]
			}
		}
		return grouped
	}
	
	func getRecentEntriesIn(interval: EntryDateStyles) -> [Entry] {
		var period = DateInterval()
		switch interval {
		case .year:
			guard let startOfInterval = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else { return [] }
			period = DateInterval(start: startOfInterval, end: Date())
		case .month:
			guard let startOfInterval = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return [] }
			period = DateInterval(start: startOfInterval, end: Date())
		case .week:
			guard let startOfInterval = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else { return [] }
			period = DateInterval(start: startOfInterval, end: Date())
		case .day:
			guard let startOfInterval = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return [] }
			period = DateInterval(start: startOfInterval, end: Date())
		default:
			break
		}
		return activeCardEntries.filter{
			guard let date = $0.date else { print("An entry was missing a date") ; return false }
			return period.contains(date)
		}
	}
	
	/// For getting entries grouped by a calendar period of time.
	/// Ex. With .day you would recieve entries on April 25th, 26th, 27th etc. regardless of current date / time
	func getEntries(entries: [Entry] = [], groupedBy dateStyle: EntryDateStyles) -> [[Entry]] {
		var input = entries
		if entries.isEmpty {
			guard let cardEntries = activeCard.entries else { return [[]] }
			input = cardEntries.map{ $0 as! Entry}
		}
		let calendar = Calendar.current
		let grouped: [DateComponents:[Entry]]
		switch dateStyle {
		case .all:
			grouped = Dictionary(grouping: input, by: {
				calendar.dateComponents([.second,.minute,.day,.month,.year], from: $0.date!)
			})
		case .day:
			grouped = Dictionary(grouping: input, by: {
				calendar.dateComponents([.day, .month, .year], from: $0.date!)
			})
		case .week:
			grouped = Dictionary(grouping: input, by: {
				calendar.dateComponents([.weekOfYear], from: $0.date!)
			})
		case .month:
			grouped = Dictionary(grouping: input, by: {
				calendar.dateComponents([.month, .year], from: $0.date!)
			})
		case .year:
			grouped = Dictionary(grouping: input, by: {
				calendar.dateComponents([.year], from: $0.date!)
			})
		}
		return grouped.map{ $0.value }.sorted(by: { (arrayOne, arrayTwo) -> Bool in
			guard let firstDate = arrayOne.first?.date,
				let secondDate = arrayTwo.first?.date else { print("Failed to sort") ; return true }
			return firstDate.compare(secondDate) == ComparisonResult.orderedAscending
		})
	}
	
	func createEntry(ofRating rating: Double, types: [FactorType]) {
		let entry = Entry(rating: rating, onCard: activeCard)
		for type in types {
			guard let name = type.name else { print("Name on factor type was nil. Mark not created."); return }
			FactorMark(name: name, entry: entry, type: type)
		}
		CoreDataManager.saveToPersistentStore()
	}
	
	func delete(entry: Entry) {
		CoreDataStack.context.delete(entry)
		CoreDataManager.saveToPersistentStore()
	}
}

