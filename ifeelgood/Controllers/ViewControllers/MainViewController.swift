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
	@IBOutlet weak var cardView: CardView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		cardView.delegate = self
		if CardController.shared.cards.isEmpty {
			// If there are no cards existing make one and set it as the active card.
			CardController.shared.createDefaultCard()
			loadCard(card: CardController.shared.activeCard!)
		} else {
			// If I try to load a card when there are cards existing & there are no active cards let's crash
			loadCard(card: CardController.shared.activeCard!)
		}
    }
	
//	func setWelcomePhrase() {
//		let random = Int(arc4random_uniform(15))
//		let phraseArray = [ "Hey good lookin'",
//							"What's cookin'?",
//							"How's life?",
//							"Hey - how are you?",
//							"Tell me about your day",
//							"You look great. What's up?",
//							"I'm listening.",
//							"I gotchu.",
//							"I'm here for you.",
//							"What do you need?",
//							"Hey there :)",
//							"Hi lovely",
//							"Hey :)",
//							"I'm all ears",
//							"How's your day been?"
//		]
//	}
}

// MARK: - Entry page delegate
extension MainViewController: CardViewDelegate {
	
	func hideCard() {
		// Sets target location and current location of card & then animates.
		let target = self.view.frame.height * 0.8
		let distanceToTranslate = target - self.cardView.frame.minY
		CardView.animate(withDuration: 0.2, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			self.cardView.active = false
		}
	}
	
	func showCard() {
		// Sets target location and current location of card & then animates.
		let target = self.view.frame.height * 0.2
		let distanceToTranslate = target - self.cardView.frame.minY
		CardView.animate(withDuration: 0.2, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			self.cardView.active = true
		}
	}
	
	func loadCard(card: Card) {
		CardController.shared.setActive(card: card)
		let target = self.view.frame.height
		let distanceToTranslate = target - self.cardView.frame.minY
		print(self.view.frame.height, self.cardView.frame.minY, distanceToTranslate)
		CardView.animate(withDuration: 0.1, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			self.cardView.active = true
			self.cardView.updateViews()
			self.showCard()
		}
	}
	
	func editCardButtonTapped() {
		beginEditCardOptionTree()
	}
	
	func addCardButtonTapped() {
		createDefaultAlert(withPrompt: "Create a new card.", message: "What would you like to start tracking?", textFieldPlaceholder: "Card Name", confirmActionName: "Add") { (input) in
			let card = Card(name: input)
			self.loadCard(card: card)
		}
	}
	
	func saveButtonTapped() {
		
		// If any of the buttons are active save the entry
		if cardView.ratingButtons.contains(where: { $0.1 == true }) {
			var rating = 0.0
			rating = cardView.ratingButtons[cardView.mindBadButton]! ? -1.0 : 0.0
			rating = cardView.ratingButtons[cardView.mindGoodButton]! ? 1.0 : 0.0
			CardController.shared.createEntry(ofRating: rating, onCard: CardController.shared.activeCard!, X: cardView.factorButtons[cardView.factorXButton]!, Y: cardView.factorButtons[cardView.factorYButton]!, Z: cardView.factorButtons[cardView.factorZButton]!)
			cardView.resetUI()
		} else {
			// If not say no
			cardView.shake()
		}
	}
}
