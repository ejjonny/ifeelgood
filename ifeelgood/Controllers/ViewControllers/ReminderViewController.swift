//
//  ReminderViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var reminderControlView: UIView!
	@IBOutlet weak var timePicker: UIDatePicker!
	@IBOutlet weak var frequencyControl: UISegmentedControl!
	@IBOutlet weak var reminderTableView: UITableView!
	
	var activeIndex: IndexPath?
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ReminderController.shared.reminders.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath) as? ReminderTableViewCell else { return UITableViewCell() }
		let reminder = ReminderController.shared.reminders[indexPath.row]
		cell.reminder = reminder
		cell.delegate = self
		cell.reminderSelected = indexPath == activeIndex ? true : false
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			let reminder = ReminderController.shared.reminders[indexPath.row]
			ReminderController.shared.delete(reminder: reminder)
			self.reminderTableView.deleteRows(at: [indexPath], with: .automatic)
		default:
			break
		}
	}
	
	
	// Mark: - Actions
	@IBAction func addReminderButtonTapped(_ sender: Any) {
		ReminderController.shared.createReminder()
		let index = ReminderController.shared.reminders.count - 1
		let path = IndexPath(item: index, section: 0)
		self.reminderTableView.insertRows(at: [path], with: .automatic)
	}
	
	@IBAction func timePickerValueChanged(_ sender: Any) {
		guard let index = activeIndex else { print("Unable to unwrap active index") ; return }
		let reminder = ReminderController.shared.reminders[index.row]
		guard let frequency = reminder.frequency else { print("Unable to unwrap reminder frequency") ; return }
		ReminderController.shared.update(reminder: reminder, isOn: reminder.isOn, timeOfDay: timePicker.date, frequency: frequency)
		reminderTableView.reloadRows(at: [index], with: .none)
	}
	
	@IBAction func frequencyControlValueChanged(_ sender: Any) {
		
	}
	
	func updateSelectedReminder() {
		guard let index = activeIndex else { print("Unable to unwrap active index") ; return }
		let reminder = ReminderController.shared.reminders[index.row]
		
		ReminderController.shared.update(reminder: reminder, isOn: reminder.isOn, timeOfDay: timePicker.date, frequency: frequency.options[frequencyControl.selectedSegmentIndex])
		reminderTableView.reloadRows(at: [index], with: .none)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Changes made on editor should change that reminder's data.
		guard let allCells = tableView.visibleCells as? [ReminderTableViewCell] else { return }
		for cell in allCells {
			cell.reminderSelected = false
			activeIndex = nil
		}
		guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell else { return }
		// If the cell is already selected just deselect all, hide control, and return
		guard cell.isSelected else {
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
				self.reminderControlView.transform = CGAffineTransform(translationX: 0, y: self.reminderControlView.bounds.height + 50)
			}, completion: nil)
			activeIndex = nil
			return
		}
		// Otherwise select cell and show control
		cell.reminderSelected = true
		activeIndex = indexPath
		guard let reminderTime = ReminderController.shared.reminders[activeIndex!.row].timeOfDay else { return }
		timePicker.date = reminderTime
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.reminderControlView.transform = CGAffineTransform(translationX: 0, y: -self.reminderControlView.bounds.height - 50)
		}, completion: nil)
	}
}

extension ReminderViewController: ReminderCellDelegate {
	func updateCellFor(reminder: Reminder) {
		guard let index = activeIndex else { return }
		self.reminderTableView.reloadRows(at: [index], with: .automatic)
	}
}
