//
//  AlertControllers.swift
//  shrinkbot
//
//  Created by Ethan John on 2/9/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func createConfirmDeleteAlert(withPrompt prompt: String?, message: String?, confirmActionName: String, confirmActionStyle: UIAlertAction.Style, completion: @escaping (Bool) -> Void){
		let alertController = UIAlertController(title: prompt, message: message, preferredStyle: .alert)
		let confirmAction = UIAlertAction(title: confirmActionName, style: confirmActionStyle) { (_) in
			completion(true)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
			completion(false)
		}
		alertController.addAction(confirmAction)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	// Creates an alert controller with specified parameters and returns a string to use on completion.
	func createDefaultAlert(withPrompt prompt: String?, message: String?, textFieldPlaceholder: String?, confirmActionName: String, textFieldText: String = "", completion: @escaping (String) -> Void){
		let alertController = UIAlertController(title: prompt, message: message, preferredStyle: .alert)
		// Confirm will complete with entered string.
		let confirmAction = UIAlertAction(title: confirmActionName, style: .default) { (_) in
			completion(alertController.textFields![0].text!)
		}
		confirmAction.isEnabled = false
		// Configures text field (if text field is empty the confirm action will be disabled).
		alertController.addTextField { textField in
			textField.placeholder = textFieldPlaceholder
			textField.text = textFieldText
			NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main, using: { (_) in
				guard let input = textField.text else { return }
				confirmAction.isEnabled = input.count > 0 ? true : false
			})
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(confirmAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	func dateStyleAlert(_ completion: @escaping (EntryDateStyles) -> (Void)) {
		let alertController = UIAlertController(title: "How do you want to view entry data?", message: nil, preferredStyle: .actionSheet)
		let byYear = UIAlertAction(title: "Year", style: .default) { (_) in
			completion(.year)
		}
		let byMonth = UIAlertAction(title: "Month", style: .default) { (_) in
			completion(.month)
		}
		let byWeek = UIAlertAction(title: "Week", style: .default) { (_) in
			completion(.week)
		}
		let byDay = UIAlertAction(title: "Day", style: .default) { (_) in
			completion(.day)
		}
		let byEntry = UIAlertAction(title: "All", style: .default) { (_) in
			completion(.all)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(byYear)
		alertController.addAction(byMonth)
		alertController.addAction(byWeek)
		alertController.addAction(byDay)
		alertController.addAction(byEntry)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func graphRangeAlert(_ completion: @escaping (GraphRangeOptions) -> (Void)) {
		let alertController = UIAlertController(title: "Choose the range of dates you want to view.", message: nil, preferredStyle: .actionSheet)
		let allTime = UIAlertAction(title: "All Time", style: .default) { (_) in
			completion(.allTime)
		}
		let today = UIAlertAction(title: "Past 24 Hours", style: .default) { (_) in
			completion(.today)
		}
		let lastWeek = UIAlertAction(title: "Past Week", style: .default) { (_) in
			completion(.thisWeek)
		}
		let lastMonth = UIAlertAction(title: "Past Month", style: .default) { (_) in
			completion(.thisMonth)
		}
		let lastYear = UIAlertAction(title: "Past Year", style: .default) { (_) in
			completion(.thisYear)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(allTime)
		alertController.addAction(today)
		alertController.addAction(lastWeek)
		alertController.addAction(lastMonth)
		alertController.addAction(lastYear)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
}

extension MainViewController {
	
	func beginEditCardOptionTree() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let switchCard = UIAlertAction(title: "Switch card", style: .default) { (_) in
			self.showSwitchCardOptions()
		}
		let editCard = UIAlertAction(title: "Edit this card", style: .default) { (_) in
			self.showEditCardOptions()
		}
		let editFactors = UIAlertAction(title: "Edit factors", style: .default) { (alert) in
			self.chooseFactor()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
			alertController.dismiss(animated: true, completion: nil)
		}
		
		alertController.addAction(switchCard)
		alertController.addAction(editCard)
		alertController.addAction(editFactors)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func showEditFactorTypeOptions(for factor: FactorType) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let renameFactor = UIAlertAction(title: "Rename factor", style: .default) { (_) in
			self.createDefaultAlert(withPrompt: "Rename this factor", message: nil, textFieldPlaceholder: "Something creative", confirmActionName: "Rename", textFieldText: factor.name ?? "", completion: { (input) in
				CardController.shared.renameFactorType(factor, withName: input)
				self.loadCard(card: CardController.shared.activeCard)
			})
		}
		let deleteFactor = UIAlertAction(title: "Delete factor", style: .destructive) { (_) in
			self.createConfirmDeleteAlert(withPrompt: "Are you sure you want to delete this factor?", message: nil, confirmActionName: "Yes, delete \(factor.name ?? "this factor")", confirmActionStyle: .destructive, completion: { (confirmed) in
				if confirmed {
					CardController.shared.deleteFactorType(factor)
					self.loadCard(card: CardController.shared.activeCard)
				}
			})
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(renameFactor)
		alertController.addAction(deleteFactor)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func chooseFactor() {
		if !CardController.shared.activeCardFactorTypes.isEmpty {
			let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			for factorType in CardController.shared.activeCardFactorTypes {
				let factorChoice = UIAlertAction(title: factorType.name, style: .default) { (_) in
					self.showEditFactorTypeOptions(for: factorType)
				}
				alertController.addAction(factorChoice)
			}
			let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
				alertController.dismiss(animated: true, completion: nil)
			}
			alertController.addAction(cancel)
			self.present(alertController, animated: true, completion: nil)
		} else {
			let alertController = UIAlertController(title: "There aren't any factors on this card yet.", message: nil, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
			alertController.addAction(okAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	func showNewFactorOptions() {
		if CardController.shared.activeCardFactorTypes.count >= 6 {
			self.createConfirmDeleteAlert(withPrompt: "There are already 6 factors on this card. Do you want to replace one?", message: nil, confirmActionName: "Edit factors", confirmActionStyle: .default) { (confirmed) in
				self.chooseFactor()
			}
		} else {
			self.createDefaultAlert(withPrompt: "Name a factor you want to keep track of.", message: nil, textFieldPlaceholder: "Your most ingenious name.", confirmActionName: "Create", completion: { (input) in
				CardController.shared.createFactorType(withName: input)
				self.loadCard(card: CardController.shared.activeCard)
			})
		}
	}
	
	func addCardButtonTapped() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let newCard = UIAlertAction(title: "New Card", style: .default) { (_) in
			self.createDefaultAlert(withPrompt: "Create a new card.", message: "What would you like to start tracking?", textFieldPlaceholder: "Card Name", confirmActionName: "Add") { (input) in
				let card = CardController.shared.createCard(named: input)
				self.loadCard(card: card)
			}
		}
		let newFactor = UIAlertAction(title: "New Factor", style: .default) { (_) in
			self.showNewFactorOptions()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
			alertController.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(newCard)
		alertController.addAction(newFactor)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func showSwitchCardOptions() {
		let alertController = UIAlertController(title: "Switch to another card.", message: nil, preferredStyle: .actionSheet)
		for card in CardController.shared.cards {
			let switchToCard = UIAlertAction(title: card.name, style: .default) { (_) in
				self.loadCard(card: card)
			}
			alertController.addAction(switchToCard)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
			alertController.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func showEditCardOptions() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let renameCard = UIAlertAction(title: "Rename card", style: .default) { (_) in
			self.showRenameCardAlert()
		}
		let deleteCard = UIAlertAction(title: "Delete card", style: .destructive) { (_) in
			self.showConfirmDeleteCard()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
			alertController.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(renameCard)
		alertController.addAction(deleteCard)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func showConfirmDeleteCard() {
		createConfirmDeleteAlert(withPrompt: "Are you sure you want to delete the current active card & all of it's data?", message: nil, confirmActionName: "Yes, delete this card.", confirmActionStyle: .destructive) { (confirmed) in
			if confirmed {
				CardController.shared.deleteActiveCard(completion: { (_) in
					self.loadCard(card: CardController.shared.activeCard)
				})
			}
		}
	}
	
	func showRenameCardAlert() {
		createDefaultAlert(withPrompt: "Rename Card", message: "A specific aspect of your wellness", textFieldPlaceholder: "Name", confirmActionName: "Rename", textFieldText: CardController.shared.activeCard.name ?? "") { (input) in
			CardController.shared.renameActiveCard(withName: input)
			self.loadCard(card: CardController.shared.activeCard)
		}
	}
}
