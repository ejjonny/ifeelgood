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
	@IBOutlet weak var insightBottomConstraint: NSLayoutConstraint!
	
	// Mark: - Params
	weak var delegate: InsightViewControllerDelegate?
	var card: Card {
		return CardController.shared.activeCard
	}
	var graphRange: GraphRangeOptions? = .today
	
	// Mark: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
    }
	
	@IBAction func graphStyleButtonTapped(_ sender: Any) {
		graphRangeAlert { (range) -> (Void) in
			self.graphRange = range
			self.graphView.graphRange = range
			self.customizeInsightPageForActiveCard{}
		}
	}
	
	func setUpViews() {
		insightBottomConstraint.constant = self.view.bounds.height * 0.2
		scrollInsetView.layer.cornerRadius = 10
		graphInsetView.layer.cornerRadius = 10
		graphView.layer.borderWidth = 1
		graphView.layer.borderColor = deepChillBlue.cgColor
		graphView.layer.cornerRadius = 10
		dateStyleButton.layer.cornerRadius = 5
		nameLabel.layer.cornerRadius = 5
		dateStartedLabel.layer.cornerRadius = 5
		updateDateStyleLabel()
	}
	
	fileprivate func updateDateStyleLabel() {
		var dateButtonText: String
		guard let range = self.graphRange else { return }
		switch range {
		case .allTime :
			dateButtonText = "All Time"
		case .thisYear:
			dateButtonText = "Past Year"
		case .thisMonth:
			dateButtonText = "Past Month"
		case .thisWeek :
			dateButtonText = "Past Week"
		case .today:
			dateButtonText = "Today"
		}
		dateStyleButton.setTitle(dateButtonText, for: .normal)
	}
	
	func customizeInsightPageForActiveCard(_ completion: @escaping () -> ()) {
		if let range = self.graphRange {
			self.graphView.graphCurrentEntryDataWith(range: range, { (success) in
				self.noDataLabel.text = success ? "" : "No Data"
			})
		} else {
			self.graphView.graphCurrentEntryDataWith(range: .allTime , { (success) in
				self.noDataLabel.text = success ? "" : "No Data"
			})
		}
		self.nameLabel.text = self.card.name
		if let date = self.card.startDate {
			self.dateStartedLabel.text = "Started \(date.asString())."
		}
		self.updateDateStyleLabel()
		completion()
	}
}

protocol InsightViewControllerDelegate: class {
	
}
