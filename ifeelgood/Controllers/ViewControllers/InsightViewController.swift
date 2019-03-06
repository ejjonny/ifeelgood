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
	@IBOutlet weak var graphInsetView: UIView!
	@IBOutlet weak var scrollInsetView: UIView!
	
	// Mark: - Params
	weak var delegate: InsightViewControllerDelegate?
	var card: Card {
		return CardController.shared.activeCard
	}
	
	// Mark: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
    }
	
	@IBAction func dateStyleButtonTapped(_ sender: Any) {
		dateStyleAlert{
			self.customizeInsightPageForActiveCard{
				self.updateDateStyleLabel()
			}
		}
	}
	
	func setUpViews() {
		scrollInsetView.layer.cornerRadius = 10
		graphInsetView.layer.cornerRadius = 10
		graphView.layer.borderWidth = 1
		graphView.layer.borderColor = deepChillBlue.cgColor
		graphView.layer.cornerRadius = 10
		dateStyleButton.layer.cornerRadius = 5
		nameLabel.layer.cornerRadius = 5
		dateStartedLabel.layer.cornerRadius = 5
	}
	
	fileprivate func updateDateStyleLabel() {
		var dateButtonText: String
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
	
	func customizeInsightPageForActiveCard(_ completion: @escaping () -> ()) {
		graphView.graphCurrentEntryData { (graphed) in
			self.noDataLabel.text = graphed ? "" : "No Data"
			self.nameLabel.text = self.card.name
			self.dateStartedLabel.text = self.card.startDate?.asString()
			self.updateDateStyleLabel()
			completion()
		}
	}
}

protocol InsightViewControllerDelegate: class {
	
}
