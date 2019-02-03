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

	var mindBadButtonActive = false
	var mindNeutralButtonActive = false
	var mindGoodButtonActive = false
	
	weak var delegate: EntryPageViewDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
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
	
	@IBAction func mindBadButtonTapped(sender: UIButton) {
		if mindBadButtonActive {
			mindBadButtonActive = false
			mindNeutralButtonActive = false
			mindGoodButtonActive = false
		} else {
			mindBadButtonActive = true
			mindNeutralButtonActive = false
			mindGoodButtonActive = false
		}
		updateViews()
	}
	@IBAction func mindNeutralButtonTapped(sender: UIButton) {
		if mindNeutralButtonActive {
			mindBadButtonActive = false
			mindNeutralButtonActive = false
			mindGoodButtonActive = false
		} else {
			mindBadButtonActive = false
			mindNeutralButtonActive = true
			mindGoodButtonActive = false
		}

		updateViews()
	}
	@IBAction func mindGoodButtonTapped(sender: UIButton) {
		if mindGoodButtonActive {
			mindBadButtonActive = false
			mindNeutralButtonActive = false
			mindGoodButtonActive = false
		} else {
			mindBadButtonActive = false
			mindNeutralButtonActive = false
			mindGoodButtonActive = true
		}
		updateViews()
	}
	@IBAction func submitButtonTapped(sender: UIButton) {
		print("Saving an Entry should happen here")
	}
	
	// TODO: - submit entry button that will tell delegate which will evaluate button statuses and create an Entry.
	
	func updateViews() {
		mindBadButton.setImage(mindBadButtonActive ? UIImage(named: "BA") : UIImage(named: "BI"), for: .normal)
		mindNeutralButton.setImage(mindNeutralButtonActive ? UIImage(named: "NA") : UIImage(named: "NI"), for: .normal)
		mindGoodButton.setImage(mindGoodButtonActive ? UIImage(named: "GA") : UIImage(named: "GI"), for: .normal)
	}
	
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

protocol EntryPageViewDelegate: class {
	func ratingButtonTapped()
}
