//
//  CardTableViewController.swift
//  shrinkbot
//
//  Created by Ethan John on 3/4/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class CardTableViewController: UITableViewController {
	
	var dateStyle: EntryDateStyles?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardController.shared.cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardTableViewCell else { return UITableViewCell()}
		cell.card = CardController.shared.cards[indexPath.row]
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dateStyleAlert { style in
			self.dateStyle = style
			self.performSegue(withIdentifier: "toEntries", sender: self)
		}
	}

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toEntries" {
			guard let index = tableView.indexPathForSelectedRow else { return }
			guard let destination = segue.destination as? EntryTableViewController else { return }
			destination.card = CardController.shared.cards[index.row]
			destination.dateStyle = self.dateStyle
		}
    }
}
