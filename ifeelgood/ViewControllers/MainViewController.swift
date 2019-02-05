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
		
		if entryPage.ratingButtons.contains(where: { $0.1 == true }) {
			var rating = 0.0
			rating = entryPage.ratingButtons[entryPage.mindBadButton]! ? -1.0 : 0.0
			rating = entryPage.ratingButtons[entryPage.mindGoodButton]! ? 1.0 : 0.0
			EntryController.shared.createEntryWith(mindRating: rating)
			entryPage.resetUI()
		} else {
			entryPage.ratingCardView.shake()
		}
	}
}
