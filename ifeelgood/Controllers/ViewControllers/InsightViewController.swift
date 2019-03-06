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
			self.graphCurrentEntryData{
				self.updateDateStyleLabel()
			}
		}
	}
	
	func setUpViews() {
		graphInsetView.layer.cornerRadius = 10
		graphView.layer.borderWidth = 0.3
		graphView.layer.borderColor = deepChillBlue.cgColor
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
	
	func graphCurrentEntryData(_ completion: @escaping () -> ()) {
		switch CardController.shared.entryDateStyle {
		case .all:
			let entries = CardController.shared.activeCardEntries
			if entries.count > 1 {
				noDataLabel.text = ""
				bezierWithValues(onView: graphView, YValues: entries.compactMap{ CGFloat($0.rating) }, smoothing: 0.3, inset: 10) { (path) in
					self.graphView.path = path
					self.graphView.setNeedsDisplay()
				}
			} else {
				noDataLabel.text = "No Data"
				self.graphView.clearGraph()
			}
		default:
			let entries = CardController.shared.entriesWithDateStyle()
			if entries.count > 1 {
				noDataLabel.text = ""
				bezierWithValues(onView: graphView, YValues: entries.compactMap{ CGFloat($0.averageRating)}, smoothing: 0.3, inset: 10) { path in
					self.graphView.path = path
					self.graphView.setNeedsDisplay()
				}
			} else {
				noDataLabel.text = "No Data"
				self.graphView.clearGraph()
			}
		}
		nameLabel.text = card.name
		dateStartedLabel.text = card.startDate?.asString()
		updateDateStyleLabel()
		completion()
	}
}

protocol InsightViewControllerDelegate: class {
	
}
