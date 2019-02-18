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
		
	var organization = organizationType.all
	
	var card: Card?

    override func viewDidLoad() {
        super.viewDidLoad()
		titleLabel.title = card?.name
	}

	@IBAction func doneButtonTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch organization {
		case .all:
			break
		case .day:
			break
		case .month:
			break
		case .year:
			break
		}
        return card?.entries?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
		// Sort from newest to oldest
		let index = (card?.entries?.count)! - indexPath.row - 1
		// Cast entry as Entry object
		guard let entry = card?.entries?[index] as? Entry else { return UITableViewCell()}
		cell.textLabel?.text = String(entry.rating)
		cell.detailTextLabel?.text = entry.date?.asString()
        return cell
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
