//
//  InsightViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 3/5/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

let legendColors = [#colorLiteral(red: 0.7883887887, green: 0.7393109202, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.8194651824, blue: 0.894031874, alpha: 1), #colorLiteral(red: 1, green: 0.9575231352, blue: 0.7737829244, alpha: 1), #colorLiteral(red: 0.7617713751, green: 1, blue: 0.8736094954, alpha: 1), #colorLiteral(red: 0.9207964755, green: 0.6802755262, blue: 1, alpha: 1), #colorLiteral(red: 0.7044421855, green: 0.9814820289, blue: 1, alpha: 1)]

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
	
	// MARK: - Params
	weak var delegate: InsightViewControllerDelegate?
	var card: Card {
		return CardController.shared.activeCard
	}
	var graphRange: GraphRangeOptions? = .today
	var insights = [Insight]()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setUpViews()
		InsightGenerator.shared.generate { (insights) in
			self.insights = insights
			self.insightCollectionView.reloadData()
			self.insightPageControl.numberOfPages = insights.count
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		insightCollectionView.reloadData()
	}
	
	// MARK: - Actions
	@IBAction func graphStyleButtonTapped(_ sender: Any) {
		graphRangeAlert { (range) -> (Void) in
			self.graphRange = range
			self.graphView.graphRange = range
			self.customizeInsightPageForActiveCard{}
		}
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
		if CardController.shared.activeCardFactorTypes.indices.contains(0) {
			self.factorTypeOneLabel.text = CardController.shared.activeCardFactorTypes[0].name
		}
		if CardController.shared.activeCardFactorTypes.indices.contains(1) {
			self.factorTypeTwoLabel.text = CardController.shared.activeCardFactorTypes[1].name
		}
		if CardController.shared.activeCardFactorTypes.indices.contains(2) {
			self.factorTypeThreeLabel.text = CardController.shared.activeCardFactorTypes[2].name
		}
		self.updateDateStyleLabel()
		completion()
	}
}

// MARK: - InsightVCDelegate
protocol InsightViewControllerDelegate: class {
	
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
