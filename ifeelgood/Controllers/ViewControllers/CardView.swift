//
//  CardView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class CardView: UIView {
		
	// MARK: - Outlets
	@IBOutlet weak var ratingCardTitle: UILabel!
	@IBOutlet weak var mindBadButton: UIButton!
	@IBOutlet weak var mindNeutralButton: UIButton!
	@IBOutlet weak var superGoodButton: UIButton!
	@IBOutlet weak var superBadButton: UIButton!
	@IBOutlet weak var mindGoodButton: UIButton!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var ratingCardTitleView: UIView!
	@IBOutlet weak var panGesture: UIPanGestureRecognizer!
	@IBOutlet weak var factorXButton: UIButton!
	@IBOutlet weak var factorYButton: UIButton!
	@IBOutlet weak var factorZButton: UIButton!
	
	var ratingButtons: [UIButton: Bool] = [:]
	var factorButtons: [UIButton: Bool] = [:]
	
	weak var delegate: CardViewDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		ratingButtons = [superBadButton: false, mindBadButton: false, mindNeutralButton: false, mindGoodButton: false, superGoodButton: false]
		factorButtons = [factorXButton: false, factorYButton: false, factorZButton: false]
		initializeUI()
	}
	
	func initializeUI() {
		self.layer.cornerRadius = 10
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.08
		self.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
		self.layer.shadowRadius = 5
		submitButton.layer.cornerRadius = 10
		ratingCardTitle.layer.masksToBounds = true
		ratingCardTitle.layer.cornerRadius = 10
		ratingCardTitleView.layer.cornerRadius = 10
		factorXButton.layer.cornerRadius = 10
		factorYButton.layer.cornerRadius = 10
		factorZButton.layer.cornerRadius = 10
		factorXButton.setTitle("", for: .normal)
		factorYButton.setTitle("", for: .normal)
		factorZButton.setTitle("", for: .normal)
	}
	
	func updateButtonStatuses(for button: UIButton) {
		if self.ratingButtons[button]! {
			// If an active rating is tapped all should be set to false
			self.ratingButtons[button] = false
		} else {
			// If an inactive rating is tapped all will be set to false except for the tapped button
			for (key, _) in self.ratingButtons {
				self.ratingButtons[key] = key == button ? true : false
			}
		}
	}
	
	func toggleActive(for sender: UIButton) {
		self.factorButtons[sender] = !self.factorButtons[sender]!
	}
	
	// MARK: - Actions
	
	@IBAction func superBadButtonTapper(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
		delegate?.userDidInteractWithCard()
	}
	
	@IBAction func superGoodButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
		delegate?.userDidInteractWithCard()
	}
	
	@IBAction func badButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func neutralButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func goodButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func factorXButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		if CardController.shared.activeCardFactorTypes.indices.contains(0) {
			self.toggleActive(for: sender)
			updateViews()
		}
		delegate?.userDidInteractWithCard()
	}
	@IBAction func factorYButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		if CardController.shared.activeCardFactorTypes.indices.contains(1) {
			self.toggleActive(for: sender)
			updateViews()
		}
		delegate?.userDidInteractWithCard()
	}
	@IBAction func factorZButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		if CardController.shared.activeCardFactorTypes.indices.contains(2) {
			self.toggleActive(for: sender)
			updateViews()
		}
		delegate?.userDidInteractWithCard()
	}
	@IBAction func saveButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		delegate?.saveButtonTapped()
		resetUI()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func addCardButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		delegate?.addCardButtonTapped()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func editCardButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		delegate?.editCardButtonTapped()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
		switch panGesture.state {
		case .began:
			delegate?.panViews(withPanPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
			panGesture.setTranslation(CGPoint.zero, in: self)
		case .changed:
			delegate?.panViews(withPanPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
			panGesture.setTranslation(CGPoint.zero, in: self)
		case .ended:
			panGesture.setTranslation(CGPoint.zero, in: self)
			delegate?.panDidEnd()
		default:
			return
		}
	}
	
	func updateViews() {
		ratingCardTitle.text = CardController.shared.activeCard.name
		superBadButton.setImage(ratingButtons[superBadButton]! ? UIImage(named: "SBA") : UIImage(named: "SBI"), for: .normal)
		mindBadButton.setImage(ratingButtons[mindBadButton]! ? UIImage(named: "BA") : UIImage(named: "BI"), for: .normal)
		mindNeutralButton.setImage(ratingButtons[mindNeutralButton]! ? UIImage(named: "NA") : UIImage(named: "NI"), for: .normal)
		mindGoodButton.setImage(ratingButtons[mindGoodButton]! ? UIImage(named: "GA") : UIImage(named: "GI"), for: .normal)
		superGoodButton.setImage(ratingButtons[superGoodButton]! ? UIImage(named: "SGA") : UIImage(named: "SGI"), for: .normal)
		factorXButton.backgroundColor = factorButtons[factorXButton]! ? chillBlue : UIColor.clear
		factorYButton.backgroundColor = factorButtons[factorYButton]! ? chillBlue : UIColor.clear
		factorZButton.backgroundColor = factorButtons[factorZButton]! ? chillBlue : UIColor.clear
	}
	
	func resetUI() {
		// Iterate through all the values and set them to false
		for (key, _) in self.ratingButtons {
			self.ratingButtons[key] = false
		}
		for (key, _) in self.factorButtons {
			self.factorButtons[key] = false
		}
		updateViews()
	}
	
	func animateTapFor(_ button: UIButton) {
		// Depress animation for buttons
		CardView.animate( withDuration: 0.002, animations: { button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { _ in UIView.animate(withDuration: 0.1) { button.transform = CGAffineTransform.identity}})
	}
}

// MARK: - Delegate functions
protocol CardViewDelegate: class {
	func saveButtonTapped()
	func addCardButtonTapped()
	func editCardButtonTapped()
	func panDidEnd()
	func userDidInteractWithCard()
	func panViews(withPanPoint panPoint:CGPoint)
}