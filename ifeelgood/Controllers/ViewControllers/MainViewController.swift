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
	@IBOutlet weak var topBarView: UIView!
	@IBOutlet weak var topBarInsetView: UIView!
	@IBOutlet weak var welcomeLabel: UILabel!
	
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
	
	func panDidEnd() {
		// Check the state when the pan gesture ends and react accordingly with linear or velocity reactive animations.
		let aboveHalfWay = self.cardView.frame.minY < (self.view.frame.height * 0.5)
		let velocity = self.cardView.panGesture.velocity(in: self.cardView).y
		
		if velocity > 500 {
			self.hideCard()
		} else if velocity < -500 {
			self.showCard()
		} else if aboveHalfWay {
			self.autoShow()
		} else if !aboveHalfWay {
			self.autoHide()
		}
	}
	
	func userDidInteractWithCard() {
		if self.cardView.frame.minY > (self.view.frame.height * 0.5) {
			self.autoShow()
		}
	}
	
	func autoHide() {
		// Sets target locations of views & then animates.
		let cardTarget = self.view.frame.maxY - self.view.safeAreaInsets.bottom - (self.cardView.bounds.height / 5)
		self.autoAnimate(view: self.cardView, edge: self.cardView.frame.minY, to: cardTarget, completion: nil)
		
		let topBarTarget: CGFloat = 0
		self.autoAnimate(view: self.topBarView, edge: self.cardView.frame.maxY, to: topBarTarget, completion: nil)
	}
	
	func autoShow() {
		// Sets target locations of views & then animates.
		let cardTarget = self.view.frame.maxY - self.view.safeAreaInsets.bottom
		self.autoAnimate(view: self.cardView, edge: self.cardView.frame.maxY, to: cardTarget, completion: nil)
		
		let topBarTarget: CGFloat = self.view.safeAreaInsets.top
		self.autoAnimate(view: self.topBarView, edge: self.topBarView.frame.minY, to: topBarTarget, completion: nil)
	}
	
	func hideCard() {
		// Sets target locations of views & then animates.
		let cardTarget = self.view.frame.maxY - self.view.safeAreaInsets.bottom - (self.cardView.frame.height / 5)
		self.userInteractionAnimate(view: self.cardView, edge: self.cardView.frame.minY, to: cardTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y)

		let topBarTarget: CGFloat = 0
		self.userInteractionAnimate(view: self.topBarView, edge: self.topBarView.frame.maxY, to: topBarTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y)
	}
	
	func showCard() {
		// Sets target locations of views & then animates.
		let target = self.view.frame.maxY - self.view.safeAreaInsets.bottom
		self.userInteractionAnimate(view: self.cardView, edge: self.cardView.frame.maxY, to: target, velocity: self.cardView.panGesture.velocity(in: self.cardView).y)
		
		let topBarTarget: CGFloat = self.view.safeAreaInsets.top
		self.userInteractionAnimate(view: self.topBarView, edge: self.topBarView.frame.minY, to: topBarTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y)
	}
	
	func userInteractionAnimate(view: UIView, edge: CGFloat, to target: CGFloat, velocity: CGFloat) {
		let distanceToTranslate = target - edge
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: abs(velocity) * 0.01, options: .curveEaseOut , animations: {view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)}, completion: nil)
	}
	
	func autoAnimate(view: UIView, edge: CGFloat, to target: CGFloat, completion: ((Bool) -> Void)?) {
		let distanceToTranslate = target - edge
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
			view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)
		}, completion: completion)
	}
	
	func loadCard(card: Card) {
		let target = self.view.frame.height
		self.autoAnimate(view: self.cardView, edge: self.cardView.bounds.minY, to: target) { (_) in
			CardController.shared.setActive(card: card)
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
			} else {
				self.cardView.factorXLabel.text = ""
				self.cardView.factorYLabel.text = ""
				self.cardView.factorZLabel.text = ""
			}
			self.cardView.updateViews()
			self.cardView.resetUI()
			self.showCard()
		}
	}
	
	func panViews(withPanPoint panPoint: CGPoint) {
		// If user goes against necessary pan adjust reaction
		if self.cardView.frame.maxY < self.view.bounds.maxY {
			// Don't animate top bar with pan gesture
			self.cardView.center.y += cardView.panGesture.translation(in: cardView).y / 3
		} else {
			// Normal reaction
			self.cardView.center.y += cardView.panGesture.translation(in: cardView).y
			self.topBarView.center.y -= cardView.panGesture.translation(in: cardView).y / 3
		}
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
