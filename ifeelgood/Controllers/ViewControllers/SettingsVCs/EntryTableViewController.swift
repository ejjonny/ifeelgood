//
//  EntryTableViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/17/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
	
	// Mark: - Outlets
	@IBOutlet weak var titleLabel: UINavigationItem!
	
	// Mark: - Properties
	var card: Card?
	var dateStyle: EntryDateStyles?
	var entryStats: [EntryStats] {
		if let style = dateStyle {
			return CardController.shared.entriesWith(dateStyle: style)
		} else {
			return []
		}
	}

	// Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.title = CardController.shared.activeCard.name
	}

	// Mark: - Actions
	@IBAction func doneButtonTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch CardController.shared.entryDateStyle {
		case .all:
			return CardController.shared.activeCard.entries?.count ?? 0
		default:
			return entryStats.count
		}
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
		let stat = entryStats[indexPath.row]
		cell.detailTextLabel?.text = stat.name
		let roundedRating = round(stat.averageRating * 100) / 100
		if dateStyle != .all {
			cell.textLabel?.text = stat.ratingCount == 1 ? "\(stat.ratingCount) entry: rating: \(stat.averageRating)." : "\(stat.ratingCount) entries: Average rating of \(roundedRating)"
		} else {
			cell.textLabel?.text = "Rating: \(roundedRating)"
		}
		return cell
	}

//	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//			guard let entry = CardController.shared.activeCard.entries?[indexPath.row] as? Entry else { return }
//			CardController.shared.delete(entry: entry)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//	}
}
