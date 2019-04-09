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
	
	func generate(completion: @escaping ([Insight]) -> Void) {
		var insights = [Insight]()
		insights.append(contentsOf: generateOverallAnalysis())
		
		// Simple averages. Ex. On average you record (A) once every week
		// Time since last mark. Ex. It's been 18 days & 5 hours since you recorded (A)
		// Progress. Ex. This week (Main) has improved by 20% / (Main) has gotten 8% worse. How to decide the interval to look at?
		let filteredByScore = insights.filter{ $0.score > 20 }
		completion(filteredByScore)
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
			let grouped = CardController.shared.getEntries(entries: allEntries, groupedBy: interval)
			intervalAnalyses[type] = intervalAnalysesWith(groups: grouped, type: type)
		}
		var insights = [Insight]()
		for type in intervalAnalyses.keys {
			var withFactor = [Double]()
			var withoutFactor = [Double]()
			guard let analysisGroup = intervalAnalyses[type] else { continue }
			for analysis in analysisGroup {
				analysis.factorPresent ? withFactor.append(analysis.avgRating) : withoutFactor.append(analysis.avgRating)
			}
			let percentage = withoutFactor.average / withFactor.average - 1
			let percentageValue = (percentage * 100).rounded()
			
			print("\(CardController.shared.activeCard.name ?? "NaMe") is \(abs(percentageValue))% \(percentageValue > 0 ? "better" : "worse") without \(type.name ?? "NaME"). Reliability: \(analysisGroup.map{ $0.score }.reduce(0, +))")
			insights.append(Insight(title: "\(type.name) Analysis", description: "\(CardController.shared.activeCard.name ?? "NaMe") is \(abs(percentageValue))% \(percentageValue > 0 ? "better" : "worse") without \(type.name ?? "NaME")", score: analysisGroup.map{ $0.score }.reduce(0, +)))
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
	
	private func closestCalendarIntervalWith(input: TimeInterval) -> EntryDateStyles {
		var interval = EntryDateStyles.all
		// Find closest calendar interval for an interval
		if input >= 0, input < day {
			interval = .day
		} else if input >= day, input < week {
			interval = .week
		} else if input >= week, input < month {
			interval = .month
		} else if input >= month, input < year {
			print("Entries are more than a month apart. Not generating insights.")
		} else {
			print("Relevant entries are more than a year apart. Not generating any insights.")
		}
		return interval
	}
	
	private func intervalAnalysesWith(groups: [[Entry]], type: FactorType) -> [IntervalAnalysis] {
		var intervalAnalyses = [IntervalAnalysis]()
		var reliability = Double()
		for group in groups {
			var ratings = [Double]()
			var present = false
			for entry in group {
				let marks = entry.getMarks()
				marks.forEach{
					if $0.type == type {
						present = true
						reliability += 1
					}
				}
				if marks.isEmpty {
					ratings.append(entry.rating)
				}
			}
			let analysis = IntervalAnalysis(avgRating: ratings.average, forFactor: type, intervalEntries: group, factorPresent: present, reliability: reliability)
			intervalAnalyses.append(analysis)
		}
		return intervalAnalyses
	}
}
