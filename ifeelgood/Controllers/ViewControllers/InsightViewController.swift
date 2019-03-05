//
//  InsightViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class InsightViewController: UIViewController {
	
	// Mark: - Outlets
	@IBOutlet weak var graphView: GraphView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dateStartedLabel: UILabel!
	@IBOutlet weak var dateStyleButton: UIButton!
	@IBOutlet weak var insightScrollView: UIScrollView!
	@IBOutlet weak var insightPageControl: UIPageControl!
	@IBOutlet weak var noDataLabel: UILabel!
	
	// Mark: - Params
	weak var delegate: InsightViewControllerDelegate?
	var card: Card {
		return CardController.shared.activeCard
	}
	
	// Mark: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
		customizeInsightPageForCard()
    }
	
	@IBAction func dateStyleButtonTapped(_ sender: Any) {
	}
	
	func setUpViews() {
		graphView.layer.cornerRadius = 30
		dateStyleButton.layer.cornerRadius = 5
		nameLabel.layer.cornerRadius = 5
		dateStartedLabel.layer.cornerRadius = 5
	}
	
	func customizeInsightPageForCard() {
		let entries = CardController.shared.entriesByDateStyle()
		if !entries.isEmpty {
			noDataLabel.text = ""
			//			entries.map{ CGFloat($0.averageRating)}
			let graphPath = bezierWithValues(onView: graphView, YValues: [1,2,1,5], smoothing: 0.3, inset: 10)
			self.graphView.path = graphPath
		} else {
			noDataLabel.text = "No Data"
		}
		nameLabel.text = card.name
		dateStartedLabel.text = card.startDate?.asString()
		var dateButtonText = ""
		switch CardController.shared.entryDateStyle {
		case .all:
			dateButtonText = "All"
		case .day:
			dateButtonText = "Daily"
		case .week:
			dateButtonText = "Weekly"
		case .month:
			dateButtonText = "Monthly"
		case .year:
			dateButtonText = "Yearly"
		}
		dateStyleButton.setTitle(dateButtonText, for: .normal)
	}
}

protocol InsightViewControllerDelegate: class {
	
}
