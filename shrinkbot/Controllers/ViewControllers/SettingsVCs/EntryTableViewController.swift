//
//  EntryTableViewController.swift
//  shrinkbot
//
//  Created by Ethan John on 2/17/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var titleLabel: UINavigationItem!
	
	// MARK: - Properties
	var card: Card?
	var dateStyle: EntryDateStyles?
	var entryStats: [EntryStats] {
		if let style = dateStyle {
			return CardController.shared.entriesWith(dateStyle: style)
		} else {
			return []
		}
	}
	var entries = Array(CardController.shared.activeCardEntries.reversed())

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.title = "\(CardController.shared.activeCard.name ?? "Card") Entries"
	}

	// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch CardController.shared.entryDateStyle {
		case .all:
			return entries.count
		default:
			return entryStats.count
		}
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
		switch dateStyle! {
		case .all:
			let entry = entries[indexPath.row]
			cell.textLabel?.text = "Rating: \(entry.rating)"
			cell.detailTextLabel?.text = entry.date?.asString()
		default:
			let stat = entryStats[indexPath.row]
			cell.detailTextLabel?.text = stat.name
			let roundedRating = round(stat.averageRating * 100) / 100
			cell.textLabel?.text = stat.ratingCount == 1 ? "\(stat.ratingCount) entry: rating: \(stat.averageRating)." : "\(stat.ratingCount) entries: Average rating of \(roundedRating)"
		}
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard let dateStyle = dateStyle,
			dateStyle == .all else { return }
		let entry = self.entries[indexPath.row]
		switch editingStyle {
		case .delete:
			CardController.shared.delete(entry: entry)
			self.entries = CardController.shared.activeCardEntries
			tableView.deleteRows(at: [indexPath], with: .automatic)
		default:
			break
		}
	}
}
