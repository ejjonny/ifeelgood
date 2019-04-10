//
//  InsightGenerator.swift
//  ifeelgood
//
//  Created by Ethan John on 4/4/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import Foundation

class InsightGenerator {
	
	static let shared = InsightGenerator()
	let allEntries = CardController.shared.activeCardEntries
	
	func generate(completion: @escaping ([Insight]) -> Void) {
		guard allEntries.count > 10 else { completion([]) ; return  }
		var insights = [Insight]()
		insights.append(contentsOf: generateOverallAnalysis())
		insights.append(contentsOf: averageFactorFrequency())
		insights.append(contentsOf: getMainProgress())
		// Time since last mark. Ex. It's been 18 days & 5 hours since you recorded (A)
		// Progress. Ex. This week (Main) has improved by 20% / (Main) has gotten 8% worse. How to decide the interval to look at?
		let filteredByScore = insights.filter{ $0.score > 20 }
		completion(filteredByScore)
	}
	
	private func getMainProgress() -> [Insight] {
		let week = CardController.shared.getRecentEntriesIn(interval: .week)
		let month = CardController.shared.getRecentEntriesIn(interval: .month)
		let weekRatings = week.map{ $0.rating }
		let monthRatings = month.map{ $0.rating }
		let percentDifference = ((monthRatings.average / weekRatings.average - 1 * 1000).rounded()) / 100
		var description = "This week \(CardController.shared.activeCard.name ?? "Card") is \(abs(percentDifference))% \(percentDifference > 0 ? "better" : "worse") than this month's average"
		if abs(percentDifference) == 0 {
			description = "Looks like this week is about the same as the rest of the month for \(CardController.shared.activeCard.name ?? "Card")"
		}
		print(description)
		return [Insight(title: CardController.shared.activeCard.name ?? "Card", description: description, score: Double.random(in: 0...50))]
	}
	
	private func averageFactorFrequency() -> [Insight] {
		var insights = [Insight]()
		let sorted = sortIntoGroupsByFactorType(entries: allEntries)
		for type in sorted.keys {
			guard let entries = sorted[type] else { continue }
			let averageInterval = averageIntervalBetween(entries: entries)
			let calendarInterval = closestCalendarIntervalWith(input: averageInterval)
			guard let calendarIntervalSafe = calendarInterval else { continue }
			let groups = CardController.shared.getEntries(groupedBy: calendarIntervalSafe)
			let analyses = intervalAnalysesWith(groups: groups, type: type)
			var recordedPerInterval = [Int]()
			for analysis in analyses {
				recordedPerInterval.append(analysis.factorRecorded)
			}
			let roundedRecorded = ((recordedPerInterval.average * 100).rounded()) / 100
			print("On average you record \(type.name ?? "Name") \(roundedRecorded) times per \(calendarIntervalSafe.rawValue)")
			insights.append(Insight(title: "\(type.name ?? "Name") Frequency", description: "On average you record \(type.name ?? "Name") \(roundedRecorded) times every \(calendarIntervalSafe.rawValue)", score: Double.random(in: 0...80)))
		}
		return insights
	}
	
	/// Analyze data by interval - If average interval between recorded factor is >= a week we will analyze by week. Weeks with factor included are compared to weeks with factor not included. Entries that have the factor recorded on them should not be used to analyze the data otherwise it may be skewed
	private func generateOverallAnalysis() -> [Insight] {
		
		let allEntries = CardController.shared.activeCardEntries
		var entriesByFactorType = sortIntoGroupsByFactorType(entries: allEntries)
		var intervalAnalyses = [FactorType: [IntervalAnalysis]]()
		for type in entriesByFactorType.keys {
			guard let entries = entriesByFactorType[type] else { print("No entries sorted by this type") ; continue }
			let average = averageIntervalBetween(entries: entries)
			let interval = closestCalendarIntervalWith(input: average)
			guard let intervalSafe = interval else { continue }
			let grouped = CardController.shared.getEntries(entries: allEntries, groupedBy: intervalSafe)
			intervalAnalyses[type] = intervalAnalysesWith(groups: grouped, type: type)
		}
		var insights = [Insight]()
		for type in intervalAnalyses.keys {
			var withFactor = [Double]()
			var withoutFactor = [Double]()
			guard let analysisGroup = intervalAnalyses[type] else { continue }
			for analysis in analysisGroup {
				analysis.factorRecorded > 0 ? withFactor.append(analysis.avgRating) : withoutFactor.append(analysis.avgRating)
			}
			let percentage = withoutFactor.average / withFactor.average - 1
			let percentageValue = (percentage * 100).rounded()
			
			print("\(CardController.shared.activeCard.name ?? "NaMe") is \(abs(percentageValue))% \(percentageValue > 0 ? "better" : "worse") without \(type.name ?? "NaME"). Reliability: \(analysisGroup.map{ $0.score }.reduce(0, +))")
			insights.append(Insight(title: "\(type.name ?? "Name") / \(CardController.shared.activeCard.name ?? "Card") Correlation", description: "\(CardController.shared.activeCard.name ?? "Name") is \(abs(percentageValue))% \(percentageValue > 0 ? "better" : "worse") without \(type.name ?? "Name")", score: analysisGroup.map{ $0.score }.reduce(0, +)))
		}
		return insights
	}
	
	private func sortIntoGroupsByFactorType(entries: [Entry]) -> [FactorType:[Entry]] {
		var entriesByFactorType = [FactorType : [Entry]]()
		for entry in entries {
			let marks = entry.getMarks()
			for mark in marks {
				guard let type = mark.type else { continue }
				if entriesByFactorType[type] == nil {
					entriesByFactorType[type] = [entry]
				} else {
					entriesByFactorType[type]?.append(entry)
				}
			}
		}
		return entriesByFactorType
	}
	
	private func averageIntervalBetween(entries: [Entry]) -> TimeInterval {
		var lastDate: Date?
		var intervals = [TimeInterval]()
		for entry in entries {
			guard let date = entry.date else { continue }
			if lastDate != nil {
				intervals.append(date.timeIntervalSince(lastDate!))
			}
			lastDate = date
		}
		return intervals.average
	}
	
	/// Will find the smallest calendar interval that can contain the interval that is passed into the function.
	private func closestCalendarIntervalWith(input: TimeInterval) -> EntryDateStyles? {
		var interval: EntryDateStyles?
		if input >= 0, input < day {
			interval = .day
		} else if input >= day, input < week {
			interval = .week
		} else if input >= week, input < month {
			interval = .month
		} else if input >= month, input < year {
			print("Entries are more than a month apart.")
		} else {
			print("Relevant entries are more than a year apart.")
		}
		return interval
	}
	
	private func intervalAnalysesWith(groups: [[Entry]], type: FactorType) -> [IntervalAnalysis] {
		var intervalAnalyses = [IntervalAnalysis]()
		var reliability = Double()
		for group in groups {
			var ratings = [Double]()
			var factorRecorded = 0
			for entry in group {
				let marks = entry.getMarks()
				marks.forEach{
					if $0.type == type {
						factorRecorded += 1
						reliability += 1
					}
				}
				if marks.isEmpty {
					ratings.append(entry.rating)
				}
			}
			let analysis = IntervalAnalysis(avgRating: ratings.average, forFactor: type, intervalEntries: group, factorRecorded: factorRecorded, reliability: reliability)
			intervalAnalyses.append(analysis)
		}
		return intervalAnalyses
	}
}
