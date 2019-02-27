//
//  SettingsTableViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/24/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var cardCountLabel: UILabel!
	@IBOutlet weak var reminderCountLabel: UILabel!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let reminderCount = ReminderController.shared.activeReminders.count
		self.reminderCountLabel.text = reminderCount > 1 ? "\(reminderCount) active reminders" : "\(reminderCount) active reminder"
		let cardCount = CardController.shared.cards.count
		self.cardCountLabel.text = cardCount > 1 ? "\(cardCount) cards" : "\(cardCount) card"
	}
	
	@IBAction func doneButtonTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
