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
	
	var activeIndex: IndexPath? {
		didSet {
			print("Index set")
		}
	}
	
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
		guard let index = activeIndex else { return }
		ReminderController.shared.reminders[index.row].timeOfDay = timePicker.date
		reminderTableView.selectRow(at: index, animated: true, scrollPosition: .none)
		reminderTableView.reloadRows(at: [index], with: .automatic)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Get the appropriate index and assign it to activeIndex. Changes made on editor should change that reminder's data.
		guard let allCells = tableView.visibleCells as? [ReminderTableViewCell] else { return }
		for cell in allCells {
			cell.isSelected = false
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
		cell.isSelected = true
		activeIndex = indexPath
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
			self.reminderControlView.transform = CGAffineTransform(translationX: 0, y: -self.reminderControlView.bounds.height - 50)
		}, completion: nil)
	}
}

extension ReminderViewController: ReminderCellDelegate {
	func updateCellFor(reminder: Reminder) {
		guard let index = ReminderController.shared.reminders.index(of: reminder) else { return }
		let path = IndexPath(index: index)
		self.reminderTableView.reloadRows(at: [path], with: .automatic)
	}
}
