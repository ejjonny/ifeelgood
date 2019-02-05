//
//  EntryPageView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class EntryPageView: UIView {

	@IBOutlet weak var ratingCardTitle: UILabel!
	@IBOutlet weak var mindBadButton: UIButton!
	@IBOutlet weak var mindNeutralButton: UIButton!
	@IBOutlet weak var mindGoodButton: UIButton!
	@IBOutlet weak var ratingCardView: UIView!
	@IBOutlet weak var submitButton: UIButton!

	var ratingButtons: [UIButton: Bool] = [:]
	
	weak var delegate: EntryPageViewDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		ratingButtons = [mindBadButton: false, mindNeutralButton: false, mindGoodButton: false]
		ratingCardView.layer.cornerRadius = 10
		ratingCardView.layer.shadowColor = UIColor.black.cgColor
		ratingCardView.layer.shadowOpacity = 0.1
		ratingCardView.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
		ratingCardView.layer.shadowRadius = 5
		submitButton.layer.cornerRadius = 10
		ratingCardTitle.layer.masksToBounds = true
		ratingCardTitle.layer.cornerRadius = 10
//		ratingCardView.layer.shadowPath = UIBezierPath(rect: ratingCardView.bounds).cgPath
	}
	
	func updateButtonStatuses(for button: UIButton) {
		
		if self.ratingButtons[button]! {
			// If an active rating is tapped all should be set to false
			self.ratingButtons[button] = false
		} else {
			// If an inactive rating is tapped all will be set to false except for the tapped button
			for (key, _) in self.ratingButtons {
				if key != button {
					self.ratingButtons[key] = false
				} else {
					self.ratingButtons[key] = true
				}
			}
		}
	}
	
	@IBAction func mindBadButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
	}
	@IBAction func mindNeutralButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
	}
	@IBAction func mindGoodButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		updateButtonStatuses(for: sender)
		updateViews()
	}
	@IBAction func saveButtonTapped(sender: UIButton) {
		animateTapFor(sender)
		delegate?.saveButtonTapped()
		resetUI()
	}
	
	func updateViews() {
		mindBadButton.setImage(ratingButtons[mindBadButton]! ? UIImage(named: "BA") : UIImage(named: "BI"), for: .normal)
		mindNeutralButton.setImage(ratingButtons[mindNeutralButton]! ? UIImage(named: "NA") : UIImage(named: "NI"), for: .normal)
		mindGoodButton.setImage(ratingButtons[mindGoodButton]! ? UIImage(named: "GA") : UIImage(named: "GI"), for: .normal)
	}
	
	func resetUI() {
		
		// Iterate through all the values and set them to false
		for (key, _) in self.ratingButtons {
			self.ratingButtons[key] = false
		}
		updateViews()
	}
	
	func animateTapFor(_ button: UIButton) {
		// Depress animation for buttons
		EntryPageView.animate( withDuration: 0.002, animations: { button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { _ in UIView.animate(withDuration: 0.1) { button.transform = CGAffineTransform.identity}})
	}
}

protocol EntryPageViewDelegate: class {
	func saveButtonTapped()
}

extension UIView {
	func shake() {
		let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		animation.duration = 0.6
		animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, -2.5, 2.5, 0.0 ]
		layer.add(animation, forKey: "shake")
	}
}
