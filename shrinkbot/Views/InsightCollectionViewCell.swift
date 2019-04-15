//
//  InsightCollectionViewCell.swift
//  shrinkbot
//
//  Created by Ethan John on 3/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class InsightCollectionViewCell: UICollectionViewCell {
	
	// MARK: - Params
	var insight: Insight? {
		didSet {
			self.updateViews()
		}
	}
	
	// MARK: - Outlets
	@IBOutlet weak var insightTitleLabel: UILabel!
	@IBOutlet weak var insightDescriptionLabel: UILabel!
	
	// MARK: - Display control
	func updateViews() {
		guard let insight = insight else { return }
		self.insightTitleLabel.text = insight.title
		self.insightDescriptionLabel.text = insight.description
	}
}
