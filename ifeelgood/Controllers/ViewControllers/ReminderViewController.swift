//
//  ReminderViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReminderControlViewDelegate {

	// Mark: - Outlets
	@IBOutlet weak var reminderControlView: UIView!
	@IBOutlet weak var reminderTableView: UITableView!
	
	// Mark: - Properties
	var containerVC: ReminderControlView?
	var activeIndex: IndexPath? {
		didSet {
			if activeIndex == nil {
				guard let old = oldValue else { return }
				guard let cell = reminderTableView.cellForRow(at: old) as? ReminderTableViewCell else { return }
				cell.reminderSelected = false
				hideControl()
			}
			if activeIndex != nil {
				guard let cell = reminderTableView.cellForRow(at: activeIndex!) as? ReminderTableViewCell else { return }
				cell.reminderSelected = true
				showControl()
			}
		}
	}
	
	// Mark: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// Mark: - TableView data source
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
			guard let cell = tableView.visibleCells[indexPath.row] as? ReminderTableViewCell else { return }
			if cell.reminderSelected {
				activeIndex = nil
			}
			let reminder = ReminderController.shared.reminders[indexPath.row]
			ReminderController.shared.delete(reminder: reminder)
			self.reminderTableView.deleteRows(at: [indexPath], with: .automatic)
		default:
			break
		}
	}
	
	// Mark: - Actions
	@IBAction func addReminderButtonTapped(_ sender: Any) {
		ReminderController.shared.createReminderWith(date: Date(), frequency: Frequency.daily) { (success) in
			if success {
				DispatchQueue.main.async {
					let index = ReminderController.shared.reminders.count - 1
					let path = IndexPath(item: index, section: 0)
					self.reminderTableView.insertRows(at: [path], with: .automatic)
				}
			}
		}
	}
	
	// Mark: - Container segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toReminderControl" {
			guard let destination = segue.destination as? ReminderControlView else { return }
			destination.delegate = self
			containerVC = destination
		}
	}
	
	// Mark: - Control view delegate functions
	func timePickerChangedWith(date: Date) {
		updateSelectedReminderWith(date: date, frequency: nil)
	}
	
	func frequencySegmentedControlChangedWith(frequencyInt: Int) {
		guard let frequency = Frequency(rawValue: Int16(frequencyInt)) else { print("Reminder not updated") ; return }
		updateSelectedReminderWith(date: nil, frequency: frequency)
	}
	
	func updateSelectedReminderWith(date: Date?, frequency: Frequency?) {
		guard let index = activeIndex else { print("Unable to unwrap active index") ; return }
		let reminder = ReminderController.shared.reminders[index.row]
		guard let reminderTime = reminder.timeOfDay else { return }
		guard let reminderFrequency = Frequency(rawValue: reminder.frequency) else { return }
		let date = date != nil ? date : reminder.timeOfDay
		
		// Depending on what is passed in the reminder's values will be updated.
		ReminderController.shared.update(reminder: reminder, isOn: reminder.isOn, timeOfDay: date != nil ? date! : reminderTime, frequency: frequency != nil ? frequency! : reminderFrequency) { (success) in
			DispatchQueue.main.async {
				self.reminderTableView.reloadRows(at: [index], with: .none)
			}
		}
	}
	
	// Mark: - TableView delegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Changes made on editor should change that reminder's data.
		guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell else { return }
		// If the cell is already selected just deselect all, hide control, and return
		if cell.reminderSelected {
			activeIndex = nil
			return
		}
		// Otherwise select cell and show control
		cell.reminderSelected = true
		activeIndex = indexPath
		guard let activeIndex = activeIndex else { return }
		guard let reminderTime = ReminderController.shared.reminders[activeIndex.row].timeOfDay else { return }
		containerVC?.reminderTimePicker.date = reminderTime
	}
	
	func hideControl() {
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.reminderControlView.transform = CGAffineTransform(translationX: 0, y: self.reminderControlView.bounds.height + 50)
		}, completion: nil)
	}
	
	func showControl() {
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.reminderControlView.transform = CGAffineTransform(translationX: 0, y: -self.reminderControlView.bounds.height - 50)
		}, completion: nil)
	}
}

extension ReminderViewController: ReminderCellDelegate {
	func reminderSwitchToggled(reminder: Reminder) {
		ReminderController.shared.toggle(reminder: reminder)
	}
}
