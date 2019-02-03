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
	func ratingButtonTapped() {
		// TODO: - Update EntryPage button
	}
}
