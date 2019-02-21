//
//  EntryTableViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/17/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
	
	@IBOutlet weak var titleLabel: UINavigationItem!
	
	var card: Card?
	var entriesByDateStyle = CardController.shared.entriesByDateStyle()

    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.title = card?.name
	}

	@IBAction func doneButtonTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch CardController.shared.entryDateStyle {
		case .all:
			return card?.entries?.count ?? 0
		default:
			return entriesByDateStyle.count
		}
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
		// Sort from newest to oldest
		switch CardController.shared.entryDateStyle {
		case .all:
			let index = (card?.entries?.count)! - indexPath.row - 1
			// Cast entry as Entry object
			guard let entry = card?.entries?[index] as? Entry else { return UITableViewCell() }
			cell.textLabel?.text = String(round(entry.rating))
			cell.detailTextLabel?.text = entry.date?.asString()
			return cell
		case .day:
			let index = entriesByDateStyle.count - indexPath.row - 1
			cell.textLabel?.text = String("\(entriesByDateStyle[index].ratingCount) entries with an average of \(round(entriesByDateStyle[index].averageRating * 100) / 100)")
			cell.detailTextLabel?.text = entriesByDateStyle[index].name
			return cell
		default:
			return UITableViewCell()
		}
	}

    // Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
	}
}
