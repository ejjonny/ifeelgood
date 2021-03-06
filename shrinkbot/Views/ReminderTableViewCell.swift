//
//  ReminderTableViewCell.swift
//  shrinkbot
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

	@IBOutlet weak var activeMarkView: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var reminderSwitch: UISwitch!
	
	var reminderSelected = false {
		didSet {
			reminderSelected ? self.select() : self.deselect()
		}
	}
	
	var reminder: Reminder? {
		didSet{
			self.updateViews()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.activeMarkView.layer.cornerRadius = 10
		self.updateViews()
	}
	
	weak var delegate: ReminderCellDelegate?
	
	func updateViews() {
		guard let reminder = reminder else { return }
		self.timeLabel.text = reminder.timeOfDay?.asTimeSpecificString()
		self.reminderSwitch.isOn = reminder.isOn
	}
	
	@IBAction func switchToggled(_ sender: UISwitch) {
		guard let reminder = reminder else { return }
		delegate?.reminderSwitchToggled(reminder: reminder)
	}
	
	func select() {
		// Animate view moving in from left edge
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.activeMarkView.transform = CGAffineTransform(translationX: self.activeMarkView.center.x + 9, y: 0)
		}, completion: nil)
	}
	
	func deselect() {
		// Animate view moving out towards left edge
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.activeMarkView.transform = CGAffineTransform(translationX: self.activeMarkView.center.x - 9, y: 0)
		}, completion: nil)
	}
}

protocol ReminderCellDelegate: class {
	func reminderSwitchToggled(reminder: Reminder)
}
