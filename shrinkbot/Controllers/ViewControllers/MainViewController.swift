//
//  MainViewController.swift
//  shrinkbot
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var cardView: CardView!
	@IBOutlet weak var topBarView: UIView!
	@IBOutlet weak var topBarInsetView: UIView!
	@IBOutlet weak var welcomeLabel: UILabel!
	
	// MARK: - Params
	var insightContainer: InsightViewController?
	var bottomOfCardShowTarget = CGFloat()
	var topOfCardHideTarget = CGFloat()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		cardView.delegate = self
		loadCard(card: CardController.shared.activeCard)
		topBarView.layer.cornerRadius = 20
		topBarView.layer.shadowColor = UIColor.black.cgColor
		topBarView.layer.shadowOpacity = 0.08
		topBarView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		topBarView.layer.shadowRadius = 5
		topBarInsetView.layer.cornerRadius = 10
		setWelcomePhrase()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		loadCard(card: CardController.shared.activeCard)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.cardView.initializeUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bottomOfCardShowTarget = self.view.frame.maxY - self.view.safeAreaInsets.bottom
		topOfCardHideTarget = self.view.frame.maxY - self.view.safeAreaInsets.bottom - (self.cardView.bounds.height / 5)
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
	
	@IBAction func menuButtonTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "toSettings", sender: self)
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toInsight" {
			guard let destination = segue.destination as? InsightViewController else { return }
			insightContainer = destination
		}
	}
	
	func loadInsight() {
		insightContainer?.customizeInsightPageForActiveCard{}
	}
}

// MARK: - CardView delegate
extension MainViewController: CardViewDelegate {
	
	// MARK: Animation handling
	func panDidEnd() {
		// Check the state when the pan gesture ends and react accordingly with linear or velocity reactive animations.
		let aboveHalfWay = self.cardView.frame.minY < (self.view.frame.height * 0.5)
		let velocity = self.cardView.panGesture.velocity(in: self.cardView).y
		
		if velocity > 500 {
			self.hideCard()
			loadInsight()
		} else if velocity < -500 {
			self.showCard()
		} else if aboveHalfWay {
			self.autoShow()
		} else if !aboveHalfWay {
			self.autoHide()
			loadInsight()
		}
	}
	
	func userDidInteractWithCard() {
		if self.cardView.frame.minY > (self.view.frame.height * 0.5) {
			self.autoShow()
		}
	}
	
	func autoHide() {
		// Sets target locations of views & then animates.
		let cardTarget = topOfCardHideTarget
		self.autoAnimate(view: self.cardView, edge: self.cardView.frame.minY, to: cardTarget, insightAlphaTarget: 1, completion: nil)
		
		let topBarTarget: CGFloat = 0
		self.autoAnimate(view: self.topBarView, edge: self.topBarView.frame.maxY, to: topBarTarget, insightAlphaTarget: nil, completion: nil)
	}
	
	func autoShow() {
		// Sets target locations of views & then animates.
		let cardTarget = bottomOfCardShowTarget
		self.autoAnimate(view: self.cardView, edge: self.cardView.frame.maxY, to: cardTarget, insightAlphaTarget: 0, completion: nil)
		
		let topBarTarget: CGFloat = self.view.safeAreaInsets.top - (self.topBarView.frame.height / 2)
		self.autoAnimate(view: self.topBarView, edge: self.topBarView.frame.minY, to: topBarTarget, insightAlphaTarget: nil, completion: nil)
	}
	
	func hideCard() {
		cardView.contractFactorList()
		// Sets target locations of views & then animates.
		let cardTarget = topOfCardHideTarget
		self.userInteractionAnimate(view: self.cardView, edge: self.cardView.frame.minY, to: cardTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y, insightAlphaTarget: 1)

		let topBarTarget: CGFloat = 0
		self.userInteractionAnimate(view: self.topBarView, edge: self.topBarView.frame.maxY, to: topBarTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y, insightAlphaTarget: nil)
	}
	
	func showCard() {
		// Sets target locations of views & then animates.
		let target = bottomOfCardShowTarget
		self.userInteractionAnimate(view: self.cardView, edge: self.cardView.frame.maxY, to: target, velocity: self.cardView.panGesture.velocity(in: self.cardView).y, insightAlphaTarget: 0)
		
		let topBarTarget: CGFloat = self.view.safeAreaInsets.top - (self.topBarView.frame.height / 2)
		self.userInteractionAnimate(view: self.topBarView, edge: self.topBarView.frame.minY, to: topBarTarget, velocity: self.cardView.panGesture.velocity(in: self.cardView).y, insightAlphaTarget: nil)
	}
	
	func userInteractionAnimate(view: UIView, edge: CGFloat, to target: CGFloat, velocity: CGFloat, insightAlphaTarget: CGFloat?) {
		let distanceToTranslate = target - edge
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.97, initialSpringVelocity: abs(velocity) * 0.01, options: .curveEaseOut , animations: {
			view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)
			self.updateContainerVisibility()
		}, completion: nil)
	}
	
	func autoAnimate(view: UIView, edge: CGFloat, to target: CGFloat, insightAlphaTarget: CGFloat?, completion: ((Bool) -> Void)?) {
		let distanceToTranslate = target - edge
		UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
			view.frame =  view.frame.offsetBy(dx: 0, dy: distanceToTranslate)
			self.updateContainerVisibility()
		}, completion: completion)
	}
	
	func loadCard(card: Card) {
		let target = self.view.frame.height
		CardController.shared.setActive(card: card)
		self.autoAnimate(view: self.cardView, edge: self.cardView.bounds.minY, to: target, insightAlphaTarget: 0) { (_) in
			self.cardView.cardConfiguration = CardConfiguration(name: card.name!, factorsExpanded: false, factors: CardController.shared.activeCardFactorTypes.map{ ($0, false) })
		}
		self.showCard()
	}
	
	func panViews(withPanPoint panPoint: CGPoint) {
		updateContainerVisibility()
		// If user goes against necessary pan adjust reaction
		if self.cardView.frame.maxY < self.view.bounds.maxY {
			// Don't animate top bar with pan gesture
			self.cardView.center.y += cardView.panGesture.translation(in: cardView).y / 4
		} else {
			// Normal reaction
			self.cardView.center.y += cardView.panGesture.translation(in: cardView).y
			self.topBarView.center.y -= cardView.panGesture.translation(in: cardView).y / 3
		}
	}
	
	func updateContainerVisibility() {
		let travelDistance = cardView.bounds.height - (cardView.bounds.height / 5)
		let current = cardView.frame.minY - (view.bounds.height - cardView.bounds.height)
		let percentHidden = current / travelDistance
		let fraction = percentHidden < 0.01 ? 0 : percentHidden
		insightContainer?.propAnimator?.fractionComplete =  1 - fraction
	}
	
	// MARK: Card view controls
	func editCardButtonTapped() {
		beginEditCardOptionTree()
	}
	
	func saveButtonTapped() {
		guard let index = cardView.cardConfiguration?.activeRating,
			let config = cardView.cardConfiguration else { cardView.shake() ; return }
		let factors = config.factors.compactMap{ (factor, marked)  -> FactorType? in
			if marked == true {
				return factor
			} else {
				return nil
			}
		}
		CardController.shared.createEntry(ofRating: Double(index) + 1, types: factors)
		cardView.clear()
		cardView.contractFactorList()
	}
	
	func ratingTapped(index: Int?) {
		let activeRating = cardView.cardConfiguration?.activeRating
		if activeRating == nil || activeRating != index {
			cardView.cardConfiguration?.activeRating = index
		} else if activeRating == index {
			cardView.cardConfiguration?.activeRating = nil
		}
	}
}
