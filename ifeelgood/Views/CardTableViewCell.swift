//
//  CardTableViewCell.swift
//  ifeelgood
//
//  Created by Ethan John on 3/4/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dateCreatedLabel: UILabel!
	
	var card: Card? {
		didSet {
			updateViews()
		}
	}
	
	func updateViews() {
		guard let card = card else { return }
		guard let startDate = card.startDate else { return }
		nameLabel.text = card.name
		dateCreatedLabel.text = "Started: \(startDate.asString())"
	}
}
