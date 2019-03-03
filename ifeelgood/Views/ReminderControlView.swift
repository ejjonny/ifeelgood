//
//  ReminderControlView.swift
//  ifeelgood
//
//  Created by Ethan John on 3/3/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class ReminderControlView: UIView {
	
	// Mark: - Outlets
	@IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
	@IBOutlet weak var reminderTimePicker: UIDatePicker!
	
	// Mark: - Properties
	weak var delegate: ReminderControlViewDelegate?
		
	// Mark: - Actions
	@IBAction func reminderTimePickerChanged(_ sender: Any) {
		delegate?.timePickerChangedWith(date: reminderTimePicker.date)
	}
	
	@IBAction func frequencySegmentedControlChanged(_ sender: Any) {
		delegate?.frequencySegmentedControlChangedWith(frequencyInt: frequencySegmentedControl.selectedSegmentIndex)
	}
}

@objc protocol ReminderControlViewDelegate: class {
	func timePickerChangedWith(date: Date)
	func frequencySegmentedControlChangedWith(frequencyInt: Int)
}
