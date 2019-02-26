//
//  ReminderTableViewCell.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

	@IBOutlet weak var activeMarkView: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var reminderSwitch: UISwitch!
	@IBOutlet weak var frequencyLabel: UILabel!
	
	var reminder: Reminder? {
		didSet{
			self.updateViews()
		}
	}
	
	weak var delegate: ReminderCellDelegate?
	
	func updateViews() {
		guard let reminder = reminder else { return }
		self.timeLabel.text = reminder.timeOfDay?.asString()
		self.frequencyLabel.text = reminder.frequency
		self.reminderSwitch.isOn = reminder.isOn
	}
	
	@IBAction func switchToggled(_ sender: UISwitch) {
		guard let reminder = reminder else { return }
		reminder.isOn = reminderSwitch.isOn
		delegate?.updateCellFor(reminder: reminder)
	}
	
	func showAsSelected() {
		// Animate view moving in from left edge
		activeMarkView.backgroundColor = chillBlue
	}
	
	func showAsDeselected() {
		// Animate view moving out towards left edge
		activeMarkView.backgroundColor = .white
	}
}

protocol ReminderCellDelegate: class {
	func updateCellFor(reminder: Reminder)
}
