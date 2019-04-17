//
//  FactorTableViewCell.swift
//  shrinkbot
//
//  Created by Ethan John on 4/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class FactorTableViewCell: UITableViewCell {
	
	@IBOutlet weak var checkButton: UIButton!
	
	weak var delegate: FactorTableViewCellDelegate?
	var factor: (FactorType, Bool)? {
		didSet {
			updateViews()
		}
	}
	var legendColor: UIColor?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		checkButton.layer.cornerRadius = 10
	}
	
	@IBAction func checkButtonTapped(_ sender: UIButton) {
		guard let delegate = delegate else { return }
		sender.depress()
		delegate.factorTapped(cell: self)
	}
	
	func updateViews() {
		guard let factor = factor else { print("Type not set") ; return }
		checkButton.setTitle(factor.0.name, for: .normal)
		checkButton.backgroundColor = factor.1 ? legendColor : .clear
	}
}

protocol FactorTableViewCellDelegate: class {
	func factorTapped(cell: FactorTableViewCell)
}
