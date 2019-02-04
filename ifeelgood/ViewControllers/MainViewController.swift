//
//  MainViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var entryPage: EntryPageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		entryPage.delegate = self
    }
}

// MARK: - Entry page delegate
extension MainViewController: EntryPageViewDelegate {
	func saveButtonTapped() {
		var rating = 0.0
		rating = entryPage.mindBadButtonActive ? -1.0 : 0.0
		rating = entryPage.mindGoodButtonActive ? 1.0 : 0.0
		EntryController.shared.createEntryWith(mindRating: rating)
		print(EntryController.shared.entries, EntryController.shared.entries.count)
		print(EntryController.shared.entries[EntryController.shared.entries.count-1].date!)
		entryPage.resetUI()
	}
}
