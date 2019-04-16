//
//  ReminderViewController.swift
//  shrinkbot
//
//  Created by Ethan John on 2/25/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReminderControlViewDelegate {

	// MARK: - Outlets
	@IBOutlet weak var reminderControlView: UIView!
	@IBOutlet weak var reminderTableView: UITableView!
	
	// MARK: - Properties
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
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		containerVC?.view.round(radius: 20)
		reminderControlView.layer.cornerRadius = 20
		reminderControlView.addMediumShadow()
    }
	
	// MARK: - TableView data source
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
	
	// MARK: - Actions
	@IBAction func addReminderButtonTapped(_ sender: Any) {
		// New reminder at 7 AM
		ReminderController.shared.createReminderWith(date: Date(timeIntervalSince1970: 1554901258)) { (success) in
			if success {
				DispatchQueue.main.async {
					let index = ReminderController.shared.reminders.count - 1
					let path = IndexPath(item: index, section: 0)
					self.reminderTableView.insertRows(at: [path], with: .automatic)
				}
			}
		}
	}
	
	// MARK: - Container segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toReminderControl" {
			guard let destination = segue.destination as? ReminderControlView else { return }
			destination.delegate = self
			containerVC = destination
		}
	}
	
	// MARK: - Control view delegate functions
	func timePickerChangedWith(date: Date) {
		updateSelectedReminderWith(date: date)
	}
	
	func updateSelectedReminderWith(date: Date) {
		guard let index = activeIndex else { print("Unable to unwrap active index") ; return }
		let reminder = ReminderController.shared.reminders[index.row]
		ReminderController.shared.update(reminder: reminder, timeOfDay: date) { (success) in
			DispatchQueue.main.async {
				self.reminderTableView.reloadRows(at: [index], with: .none)
			}
		}
	}
	
	// MARK: - TableView delegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ReminderTableViewCell else { return }
		// If the cell is already selected just deselect all, hide control, and return
		if cell.reminderSelected {
			activeIndex = nil
			return
		}
		activeIndex = nil
		// Otherwise select cell and show control
		activeIndex = indexPath
		guard let activeIndex = activeIndex else { return }
		let reminder = ReminderController.shared.reminders[activeIndex.row]
		guard let reminderTime = reminder.timeOfDay else { return }
		
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
