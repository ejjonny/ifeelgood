//
//  ReminderViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var reminderSwitch: UISwitch!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var frequencyControl: UISegmentedControl!
	@IBOutlet weak var reminderTableView: UITableView!
	var activeReminder: Reminder?
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ReminderController.shared.reminders.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }
		let reminder = ReminderController.shared.reminders[indexPath.row]
		cell.reminderSwitch.isOn = reminder.isOn
		cell.timeLabel.text = reminder.timeOfDay?.asString()
		cell.frequencyLabel.text = reminder.frequency
		cell.delegate = self
		cell.selectionStyle = .none
		
		return cell
	}
    
	@IBAction func addReminderButtonTapped(_ sender: Any) {
		ReminderController.shared.createReminder()
		let index = ReminderController.shared.reminders.count - 1
		let path = IndexPath(item: index, section: 0)
		self.reminderTableView.insertRows(at: [path], with: .automatic)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Get the appropriate reminder and assign it to activeReminder. Changes made on editor should change that reminder's data.
		// On selection animate the editor popping up
		guard let allCells = tableView.visibleCells as? [ReminderTableViewCell] else { return }
		for cell in allCells {
			cell.showAsDeselected()
		}
		guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell else { return }
		cell.showAsSelected()
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ReminderViewController: ReminderCellDelegate {
	func updateCellFor(reminder: Reminder) {
		guard let index = ReminderController.shared.reminders.index(of: reminder) else { return }
		let path = IndexPath(index: index)
		self.reminderTableView.reloadRows(at: [path], with: .automatic)
	}
}
