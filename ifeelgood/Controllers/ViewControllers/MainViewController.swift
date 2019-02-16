//
//  MainViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	var defaultAnimationDuration = 0.5
	
	// MARK: - Outlets
	@IBOutlet weak var cardView: CardView!
	@IBOutlet weak var topBarView: UIView!
	@IBOutlet weak var welcomeLabel: UILabel!
	@IBOutlet weak var topBarInsetView: UIView!
	
	@IBOutlet weak var graphView: GraphView!
	override func viewDidLoad() {
        super.viewDidLoad()
		cardView.delegate = self
		loadCard(card: CardController.shared.activeCard)
		self.initializeUI()
    }
	
	func initializeUI() {
		topBarView.layer.cornerRadius = 10
		topBarView.layer.shadowColor = UIColor.black.cgColor
		topBarView.layer.shadowOpacity = 0.08
		topBarView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		topBarView.layer.shadowRadius = 5
		topBarInsetView.layer.cornerRadius = 10
		setWelcomePhrase()
	}
	
	func setWelcomePhrase() {
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
		let random = Int(arc4random_uniform(UInt32(phraseArray.count)))
		self.welcomeLabel.text = phraseArray[random]
	}
}

// MARK: - Entry page delegate
extension MainViewController: CardViewDelegate {
	
	func hideCard(withDuration duration: Double?) {
		var defaultDuration = self.defaultAnimationDuration
		if let duration = duration {
			defaultDuration = duration
		}
		// Sets target location and current location of card & then animates.
		let target = self.view.frame.height * 0.8
		let distanceToTranslate = target - self.cardView.frame.minY
		CardView.animate(withDuration: defaultDuration, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			self.cardView.active = false
		}
		
		let topBarTarget: CGFloat = -50
		let topBarDistanceToTranslate = topBarTarget - self.topBarView.frame.maxY
		UIView.animate(withDuration: defaultDuration, animations: {self.topBarView.frame = self.topBarView.frame.offsetBy(dx: 0, dy: topBarDistanceToTranslate)})

	}
	
	func showCard(withDuration duration: Double?) {
		var defaultDuration = self.defaultAnimationDuration
		if let duration = duration {
			defaultDuration = duration
		}
		// Sets target location and current location of card & then animates.
		let target = self.view.frame.height * 0.2
		let distanceToTranslate = target - self.cardView.frame.minY
		CardView.animate(withDuration: defaultDuration, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			self.cardView.active = true
		}
		
		let topBarTarget: CGFloat = -50
		let topBarDistanceToTranslate = topBarTarget - self.topBarView.frame.minY
		UIView.animate(withDuration: defaultDuration, animations: {self.topBarView.frame = self.topBarView.frame.offsetBy(dx: 0, dy: topBarDistanceToTranslate)})
	}
	
	func loadCard(card: Card) {
		CardController.shared.setActive(card: card)
		let target = self.view.frame.height
		let distanceToTranslate = target - self.cardView.frame.minY
		CardView.animate(withDuration: self.defaultAnimationDuration, animations: {
			self.cardView.frame =  self.cardView.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}) { (_) in
			if !CardController.shared.activeCardFactorTypes.isEmpty {
				// Selectively update factor labels
				if CardController.shared.activeCardFactorTypes.indices.contains(0) {
					self.cardView.factorXLabel.text = CardController.shared.activeCardFactorTypes[0].name
				} else {
					self.cardView.factorXLabel.text = ""
				}
				if CardController.shared.activeCardFactorTypes.indices.contains(1) {
					self.cardView.factorYLabel.text = CardController.shared.activeCardFactorTypes[1].name
				} else {
					self.cardView.factorYLabel.text = ""
				}
				if CardController.shared.activeCardFactorTypes.indices.contains(2) {
					self.cardView.factorZLabel.text = CardController.shared.activeCardFactorTypes[2].name
				} else {
					self.cardView.factorZLabel.text = ""
				}
			}
			self.cardView.active = true
			self.cardView.updateViews()
			self.cardView.resetUI()
			self.showCard(withDuration: nil)
		}
	}
	
	func panViews(withPanPoint panPoint: CGPoint) {
		self.cardView.center.y = panPoint.y
		self.topBarView.center.y -= cardView.panGesture.translation(in: cardView).y / 2
	}
	
	func editCardButtonTapped() {
		beginEditCardOptionTree()
	}
	
	func saveButtonTapped() {
		
		// If any of the buttons are active save the entry
		if cardView.ratingButtons.contains(where: { $0.1 == true }) || cardView.factorButtons.contains(where: { $0.1 == true }) {
			var rating = 0.0
			rating = cardView.ratingButtons[cardView.mindBadButton]! ? -1.0 : 0.0
			rating = cardView.ratingButtons[cardView.mindGoodButton]! ? 1.0 : 0.0
			var factors = [FactorType]()
			if cardView.factorButtons[cardView.factorXButton]! {
				factors.append(CardController.shared.activeCardFactorTypes[0])
			} else if cardView.factorButtons[cardView.factorYButton]! {
				factors.append(CardController.shared.activeCardFactorTypes[1])
			} else if cardView.factorButtons[cardView.factorZButton]! {
				factors.append(CardController.shared.activeCardFactorTypes[2])
			}
			CardController.shared.createEntry(ofRating: rating, factorMarks: factors)
			cardView.resetUI()
		} else {
			// If not say no
			cardView.shake()
		}
	}
}
