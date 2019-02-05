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
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var entryPage: EntryPageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		entryPage.delegate = self
		scrollView.delegate = self
		setWelcomePhrase()
    }
	
	func setWelcomePhrase() {
		let random = Int(arc4random_uniform(15))
		let phraseArray = [ "Hey good lookin'",
							"What's cookin'?",
							"How's life?",
							"Hey - how are you?",
							"Tell me about your day",
							"You look great. What's up?",
							"I'm listening.",
							"I gotchu.",
							"I'm here for you.",
							"What do you need?",
							"Hey there :)",
							"Hi lovely",
							"Hey :)",
							"I'm all ears",
							"How's your day been?"
		]
		entryPage.ratingCardTitle.text = phraseArray[random]
	}
}

extension MainViewController: UIScrollViewDelegate {
//	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//		let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
//		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//		animation.duration = 0.6
//		animation.values = [scrollView.contentOffset]
//		print(scrollView.contentOffset)
//		entryPage.ratingCardView.layer.add(animation, forKey: "lower")
//	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let progress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.size.width)
		let distanceToTranslate: CGFloat = 450.0
		EntryPageView.animate( withDuration: 0.002, animations: { self.entryPage.ratingCardView.transform = CGAffineTransform(translationX: 0, y: (progress/0.5) * distanceToTranslate)} , completion: nil)
	}
}

// MARK: - Entry page delegate
extension MainViewController: EntryPageViewDelegate {
	
	func addFactorButtonTapped() {
		let alertController = UIAlertController(title: "Add a factor", message: "What do you want to start tracking?", preferredStyle: .alert)
		alertController.addTextField(configurationHandler: nil)
		let createFactorAction = UIAlertAction(title: "Add", style: .default) { (_) in
			// TODO: - Add factor name from text field to array (replace old one if needed)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(createFactorAction)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
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
