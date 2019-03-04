//
//  CardTableViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 3/4/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
	
	var dateStyle: EntryDateStyles = .all

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardController.shared.cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardTableViewCell else { return UITableViewCell()}
		cell.card = CardController.shared.cards[indexPath.row]
        return cell
    }
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			createConfirmDeleteAlert(withPrompt: "Are you sure you want to delete the current active card & all of it's data?", message: nil, confirmActionName: "Yes, delete this card.", confirmActionStyle: .destructive) { (confirmed) in
				if confirmed {
					CardController.shared.deleteActiveCard(completion: { (_) in
						tableView.deleteRows(at: [indexPath], with: .automatic)
					})
				}
			}
		default:
			break
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alertController = UIAlertController(title: "How do you want to view entry data?", message: nil, preferredStyle: .actionSheet)
		let byYear = UIAlertAction(title: "Year", style: .default) { (_) in
			CardController.shared.entryDateStyle = .year
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
		let byMonth = UIAlertAction(title: "Month", style: .default) { (_) in
			CardController.shared.entryDateStyle = .month
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
		let byWeek = UIAlertAction(title: "Week", style: .default) { (_) in
			CardController.shared.entryDateStyle = .week
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
		let byDay = UIAlertAction(title: "Day", style: .default) { (_) in
			CardController.shared.entryDateStyle = .day
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
		let byEntry = UIAlertAction(title: "All", style: .default) { (_) in
			CardController.shared.entryDateStyle = .all
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(byYear)
		alertController.addAction(byMonth)
		alertController.addAction(byWeek)
		alertController.addAction(byDay)
		alertController.addAction(byEntry)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toEntries" {
			guard let index = tableView.indexPathForSelectedRow else { return }
			guard let destination = segue.destination as? EntryTableViewController else { return }
			destination.card = CardController.shared.cards[index.row]
			destination.dateStyle = dateStyle
		}
    }
}
