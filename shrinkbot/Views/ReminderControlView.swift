//
//  ReminderControlView.swift
//  shrinkbot
//
//  Created by Ethan John on 3/3/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderControlView: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var reminderTimePicker: UIDatePicker!
	
	// MARK: - Properties
	weak var delegate: ReminderControlViewDelegate?
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
		
	// MARK: - Actions
	@IBAction func reminderTimePickerChanged(_ sender: Any) {
		delegate?.timePickerChangedWith(date: reminderTimePicker.date)
	}
}
	
protocol ReminderControlViewDelegate: class {
	func timePickerChangedWith(date: Date)
}
