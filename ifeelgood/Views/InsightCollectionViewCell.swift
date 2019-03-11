//
//  InsightCollectionViewCell.swift
//  ifeelgood
//
//  Created by Ethan John on 3/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class InsightCollectionViewCell: UICollectionViewCell {
	
	// Mark: - Params
	var insight: Insight?
	
	// Mark: - Outlets
	@IBOutlet weak var insightTitleLabel: UILabel!
	@IBOutlet weak var insightDescriptionLabel: UILabel!
	
	// Mark: - Lifecycle
	override func awakeFromNib() {
		super.awakeFromNib()
		updateViews()
	}
	
	// Mark: - Display control
	func updateViews() {
		guard let insight = insight else { return }
		self.insightTitleLabel.text = insight.title
		self.insightDescriptionLabel.text = insight.description
	}
}
