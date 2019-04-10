//
//  CardView.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class CardView: UIView {
		
	// MARK: - Outlets
	@IBOutlet weak var ratingCardTitle: UILabel!
	@IBOutlet weak var mindBadButton: UIButton!
	@IBOutlet weak var mindNeutralButton: UIButton!
	@IBOutlet weak var superGoodButton: UIButton!
	@IBOutlet weak var superBadButton: UIButton!
	@IBOutlet weak var mindGoodButton: UIButton!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var ratingCardTitleView: UIView!
	@IBOutlet weak var panGesture: UIPanGestureRecognizer!
	@IBOutlet weak var addFactorButton: UIButton!
	@IBOutlet weak var factorTableView: UITableView!
	@IBOutlet weak var factorView: UIView!
	
	weak var delegate: CardViewDelegate?
	var cardConfiguration: CardConfiguration? {
		didSet {
			updateViews()
		}
	}
	var ratings = [UIButton]()
	var activeRatingImages = [UIImage]()
	var inactiveRatingImages = [UIImage]()
	
	func initializeUI() {
		ratings = [superBadButton, mindBadButton, mindNeutralButton, mindGoodButton, superGoodButton]
		activeRatingImages = [#imageLiteral(resourceName: "SBA"), #imageLiteral(resourceName: "BA"), #imageLiteral(resourceName: "NA"), #imageLiteral(resourceName: "GA"), #imageLiteral(resourceName: "SGA")]
		inactiveRatingImages = [#imageLiteral(resourceName: "SBI"), #imageLiteral(resourceName: "BI"), #imageLiteral(resourceName: "NI"), #imageLiteral(resourceName: "GI"), #imageLiteral(resourceName: "SGI")]
		self.layer.cornerRadius = 15
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.08
		self.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
		self.layer.shadowRadius = 5
		submitButton.layer.cornerRadius = 10
		ratingCardTitle.layer.masksToBounds = true
		ratingCardTitle.layer.cornerRadius = 10
		ratingCardTitleView.layer.cornerRadius = 10
		factorTableView.roundBottom(radius: 10)
		addFactorButton.round(radius: 10)
		factorTableView.frame = CGRect(origin: factorTableView.frame.origin, size: CGSize(width: factorTableView.bounds.width, height: 0))
		factorTableView.delegate = self
		factorTableView.dataSource = self
		factorTableView.reloadData()
	}
	
	func updateViews() {
		guard let cardConfiguration = cardConfiguration else { print("No card config") ; return }
		factorTableView.reloadData()
		self.ratingCardTitle.text = cardConfiguration.name
		for i in ratings.indices {
			if cardConfiguration.activeRating == i {
				ratings[i].setImage(activeRatingImages[i], for: .normal)
			} else {
				ratings[i].setImage(inactiveRatingImages[i], for: .normal)
			}
		}
	}
	
	func clear() {
		cardConfiguration?.activeRating = nil
		guard let cardConfig = cardConfiguration else { return }
		for i in cardConfig.factors.indices {
			cardConfig.factors[i].1 = false
		}
		updateViews()
	}
	
	// MARK: - Actions
	@IBAction func superBadButtonTapper(sender: UIButton) {
		sender.depress()
		delegate?.userDidInteractWithCard()
		delegate?.ratingTapped(index: 0)
		updateViews()
	}
	@IBAction func badButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.userDidInteractWithCard()
		delegate?.ratingTapped(index: 1)
		updateViews()
	}
	@IBAction func neutralButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.userDidInteractWithCard()
		delegate?.ratingTapped(index: 2)
		updateViews()
	}
	@IBAction func goodButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.userDidInteractWithCard()
		delegate?.ratingTapped(index: 3)
		updateViews()
	}
	@IBAction func superGoodButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.userDidInteractWithCard()
		delegate?.ratingTapped(index: 4)
		updateViews()
	}
	
	@IBAction func saveButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.saveButtonTapped()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func addCardButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.addCardButtonTapped()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func editCardButtonTapped(sender: UIButton) {
		sender.depress()
		delegate?.editCardButtonTapped()
		delegate?.userDidInteractWithCard()
	}
	@IBAction func addFactorButtonTapped(sender: UIButton) {
		guard let cardConfig = cardConfiguration else { print("No card config") ; return }
		cardConfig.factorsExpanded = !cardConfig.factorsExpanded
		if cardConfig.factorsExpanded {
			// Expand
			self.expandFactorList()
		} else {
			// Contract
			self.contractFactorList()
		}
	}
	@IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
		switch panGesture.state {
		case .began:
			delegate?.panViews(withPanPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
			panGesture.setTranslation(CGPoint.zero, in: self)
		case .changed:
			delegate?.panViews(withPanPoint: CGPoint(x: self.center.x, y: self.center.y + panGesture.translation(in: self).y))
			panGesture.setTranslation(CGPoint.zero, in: self)
		case .ended:
			panGesture.setTranslation(CGPoint.zero, in: self)
			delegate?.panDidEnd()
		default:
			return
		}
	}
	
	func expandFactorList() {
		cardConfiguration?.factorsExpanded = true
		UIView.animate(withDuration: 0.1, animations: {
			self.addFactorButton.roundTop(radius: 10)
		}) { _ in
			UIView.animate(withDuration: 0.2) {
				self.factorTableView.frame = CGRect(origin: self.factorTableView.frame.origin, size: CGSize(width: self.factorTableView.bounds.width, height: self.factorView.frame.height - self.addFactorButton.frame.height - 10))
				self.factorTableView.roundBottom(radius: 10)
			}
		}
	}
	
	func contractFactorList() {
		cardConfiguration?.factorsExpanded = false
		UIView.animate(withDuration: 0.2, animations: {
			self.factorTableView.frame = CGRect(origin: self.factorTableView.frame.origin, size: CGSize(width: self.factorTableView.bounds.width, height: 0))
		}) { _ in
			UIView.animate(withDuration: 0.1) {
				self.addFactorButton.round(radius: 10)
			}
		}
	}
}

extension CardView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cardConfiguration?.factors.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "factorCell", for: indexPath) as! FactorTableViewCell
		cell.factor = cardConfiguration?.factors[indexPath.row]
		cell.delegate = self
		return cell
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		factorTableView.roundBottom(radius: 10)
	}
}

extension CardView: FactorTableViewCellDelegate {
	func factorTapped(cell: FactorTableViewCell) {
		let index = factorTableView.indexPath(for: cell)
		cell.factor!.1 = !cell.factor!.1
		cardConfiguration?.factors[(index?.row)!].1 = cell.factor!.1
	}
}

// MARK: - Delegate functions
protocol CardViewDelegate: class {
	func ratingTapped(index: Int?)
	func saveButtonTapped()
	func addCardButtonTapped()
	func editCardButtonTapped()
	func panDidEnd()
	func userDidInteractWithCard()
	func panViews(withPanPoint panPoint:CGPoint)
}
