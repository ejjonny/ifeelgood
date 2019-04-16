//
//  InsightViewController.swift
//  shrinkbot
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

fileprivate enum FactorPage {
	case first
	case second
}

class InsightViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var graphView: GraphView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dateStartedLabel: UILabel!
	@IBOutlet weak var dateStyleButton: UIButton!
	@IBOutlet weak var insightPageControl: UIPageControl!
	@IBOutlet weak var noDataLabel: UILabel!
	@IBOutlet weak var graphInsetView: UIView!
	@IBOutlet weak var factorTypeOneColor: UIView!
	@IBOutlet weak var factorTypeTwoColor: UIView!
	@IBOutlet weak var factorTypeThreeColor: UIView!
	@IBOutlet weak var factorTypeOneLabel: UILabel!
	@IBOutlet weak var factorTypeTwoLabel: UILabel!
	@IBOutlet weak var factorTypeThreeLabel: UILabel!
	@IBOutlet weak var insightCollectionView: UICollectionView!
	@IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
	@IBOutlet weak var insightNoDataLabel: UILabel!
	
	// MARK: - Params
	var card: Card {
		return CardController.shared.activeCard
	}
	var graphRange: GraphRangeOptions? = .today
	var insights = [Insight]()
	var factorInfo: [(UIView, UILabel)] = []
	var allFactors = [FactorType]()
	fileprivate var factorPage: FactorPage = .first
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
		factorInfo = [(factorTypeOneColor, factorTypeOneLabel), (factorTypeTwoColor, factorTypeTwoLabel), (factorTypeThreeColor, factorTypeThreeLabel)]
		NotificationCenter.default.addObserver(self, selector: #selector(refreshInsights), name: Notification.Name(rawValue: "loadedFromCoreData"), object: nil)
    }
	
	// MARK: - Actions
	@IBAction func graphStyleButtonTapped(_ sender: Any) {
		graphRangeAlert { (range) -> (Void) in
			self.graphRange = range
			self.graphView.graphRange = range
			self.customizeInsightPageForActiveCard{}
		}
	}
	
	@IBAction func tapRecognized(_ sender: UITapGestureRecognizer) {
		if factorPage == .first {
			factorPage = .second
		} else {
			factorPage = .first
		}
		displayFactors()
	}
	
	// MARK: - Functions
	func setUpViews() {
		factorTypeOneColor.backgroundColor = legendColors[0]
		factorTypeOneColor.layer.cornerRadius = factorTypeOneColor.bounds.width / 2
		factorTypeTwoColor.backgroundColor = legendColors[1]
		factorTypeTwoColor.layer.cornerRadius = factorTypeTwoColor.bounds.width / 2
		factorTypeThreeColor.backgroundColor = legendColors[2]
		factorTypeThreeColor.layer.cornerRadius = factorTypeThreeColor.bounds.width / 2
		insightCollectionView.layer.cornerRadius = 10
		graphInsetView.layer.cornerRadius = 10
		graphView.layer.borderWidth = 1
		graphView.layer.borderColor = deepChillBlue.cgColor
		graphView.layer.cornerRadius = 10
		dateStyleButton.layer.cornerRadius = 5
		nameLabel.layer.cornerRadius = 5
		dateStartedLabel.layer.cornerRadius = 5
		updateDateStyleLabel()
	}
	
	func displayFactors() {
		var range = 0...2
		switch factorPage {
		case .first:
			break
		case .second:
			range = 3...5
		}
		for i in range {
			let info = factorInfo[i > 2 ? i - 3 : i]
			if allFactors.indices.contains(i) {
				info.0.backgroundColor = legendColors[i]
				info.1.text = allFactors[i].name
				info.1.backgroundColor = .clear
			} else {
				info.0.backgroundColor = middleChillBlue
				info.1.text = "                 "
				info.1.backgroundColor = middleChillBlue
			}
		}
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
			dateButtonText = "Past 24 Hours"
		}
		dateStyleButton.setTitle(dateButtonText, for: .normal)
	}
	
	func customizeInsightPageForActiveCard(_ completion: @escaping () -> ()) {
		if let range = self.graphRange {
			self.graphView.graphCurrentEntryDataWith(range: range, { (success) in
				self.noDataLabel.text = success ? "" : "Not enough data..."
			})
		} else {
			self.graphView.graphCurrentEntryDataWith(range: .allTime , { (success) in
				self.noDataLabel.text = success ? "" : "Not enough data..."
			})
		}
		self.nameLabel.text = self.card.name
		if let date = self.card.startDate {
			self.dateStartedLabel.text = "Started \(date.asString())."
		}
		self.updateDateStyleLabel()
		allFactors = CardController.shared.activeCardFactorTypes
		self.factorPage = .first
		displayFactors()
		guard insights.count > 0 else {
			self.insightNoDataLabel.text = "I don't have enough info to generate any insights yet... check back in soon!"
			self.insightPageControl.numberOfPages = 0
			completion()
			return
		}
		self.insightNoDataLabel.text = ""
		self.insightCollectionView.reloadData()
		self.insightPageControl.numberOfPages = insights.count
		completion()
	}
	
	@objc func refreshInsights() {
		InsightGenerator.shared.generate { (insights) in
			self.insights = insights
			self.insightCollectionView.reloadData()
		}
	}
}

// MARK: - Collection View control
extension InsightViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return insights.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insightCell", for: indexPath) as? InsightCollectionViewCell else { print("Unable to correctly cast cell") ; return UICollectionViewCell()}
		cell.layer.cornerRadius = 10
		cell.addSoftShadow()
		cell.insight = self.insights[indexPath.row]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.bounds.width * 0.9, height: collectionView.bounds.height - 20)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return self.view.bounds.width * 0.1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: self.view.bounds.width * 0.05, bottom: 0, right: self.view.bounds.width * 0.05)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let cellWidth = scrollView.frame.width
		let offset = scrollView.contentOffset.x
		insightPageControl.currentPage = Int(offset + cellWidth / 2) / Int(cellWidth)
	}
}
