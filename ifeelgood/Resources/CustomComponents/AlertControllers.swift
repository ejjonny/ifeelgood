//
//  AlertControllers.swift
//  ifeelgood
//
//  Created by Ethan John on 2/9/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

extension MainViewController {
	
	// Creates an alert controller with specified parameters and returns a string to use on completion.
	func createDefaultAlert(withPrompt prompt: String?, message: String?, textFieldPlaceholder: String?, confirmActionName: String, completion: @escaping (String) -> Void){
		let alertController = UIAlertController(title: prompt, message: message, preferredStyle: .alert)
		// Confirm will complete with entered string.
		let confirmAction = UIAlertAction(title: confirmActionName, style: .default) { (_) in
			completion(alertController.textFields![0].text!)
		}
		
		confirmAction.isEnabled = false
		
		// Configures text field (if text field is empty the confirm action will be disabled).
		alertController.addTextField { textField in
			textField.placeholder = textFieldPlaceholder
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
	
	func beginEditCardOptionTree() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let switchCard = UIAlertAction(title: "Switch card", style: .default) { (_) in
			// TODO: - show a list of the cards and then switch to the one picked.
		}
		let editCard = UIAlertAction(title: "Edit this card", style: .default) { (_) in
			self.showEditCardOptions()
		}
		let editFactors = UIAlertAction(title: "Edit factors", style: .default) { (alert) in
			// TODO: - If there are already 3 factors filled I need to ask if user wants to replace one & confirm destruction. Otherwise add one.
			self.createDefaultAlert(withPrompt: "Name your factor", message: nil, textFieldPlaceholder: "Your most ingenious name.", confirmActionName: "Create", completion: { (input) in
				if CardController.shared.activeCard?.factorX == nil || CardController.shared.activeCard?.factorY == nil || CardController.shared.activeCard?.factorZ == nil  {
					CardController.shared.createFactor(withName: input)
					self.reloadCard()
				} else {
					// TODO: - Ask if the user wants to replace a factor here & proceed accordingly
				}
			})
			
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
	
	func showEditCardOptions() {
		let alertController = UIAlertController(title: "Edit this card", message: nil, preferredStyle: .actionSheet)
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
		let alertController = UIAlertController(title: "Are you sure you want to delete the current active card & all of it's data?", message: nil, preferredStyle: .alert)
		let confirm = UIAlertAction(title: "Yes, delete this card.", style: .destructive) { (_) in
			CardController.shared.deleteActiveCard()
			if CardController.shared.cards.isEmpty {
				CardController.shared.createDefaultCard()
				self.loadCard(card: CardController.shared.activeCard!)
			} else {
				self.loadCard(card: CardController.shared.cards.last!)
			}
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
			alertController.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(confirm)
		alertController.addAction(cancel)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func showRenameCardAlert() {
		createDefaultAlert(withPrompt: "Rename Card", message: "A specific aspect of your wellness", textFieldPlaceholder: "Name", confirmActionName: "Rename") { (input) in
			CardController.shared.renameActiveCard(withName: input)
			self.loadCard(card: CardController.shared.activeCard!)
		}
	}


}
