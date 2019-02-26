//
//  ReminderTableViewCell.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

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
}

protocol ReminderCellDelegate: class {
	func updateCellFor(reminder: Reminder)
}
