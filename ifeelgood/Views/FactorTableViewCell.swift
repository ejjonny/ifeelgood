//
//  FactorTableViewCell.swift
//  ifeelgood
//
//  Created by Ethan John on 4/10/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class FactorTableViewCell: UITableViewCell {
	
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var factorLabel: UILabel!
	
	weak var delegate: FactorTableViewCellDelegate?
	var factor: (FactorType, Bool)? {
		didSet {
			updateViews()
		}
	}
	
	@IBAction func checkButtonTapped(_ sender: UIButton) {
		guard let delegate = delegate else { return }
		sender.depress()
		delegate.factorTapped(cell: self)
	}
	
	func updateViews() {
		guard let factor = factor else { print("Type not set") ; return }
		factorLabel.text = factor.0.name
		checkButton.setImage(factor.1 ? #imageLiteral(resourceName: "Checked") : #imageLiteral(resourceName: "Unchecked"), for: .normal)
	}
}

protocol FactorTableViewCellDelegate: class {
	func factorTapped(cell: FactorTableViewCell)
}
