//
//  MainViewController.swift
//  ifeelgood
//
//  Created by Ethan John on 2/2/19.
//  Copyright © 2019 ya boy E. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var cardView: CardView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		cardView.delegate = self
		setWelcomePhrase()
    }
	
	func setWelcomePhrase() {
		let random = Int(arc4random_uniform(15))
		let phraseArray = [ "Hey good lookin'",
							"What's cookin'?",
							"How's life?",
							"Hey - how are you?",
							"Tell me about your day",
							"You look great. What's up?",
							"I'm listening.",
							"I gotchu.",
							"I'm here for you.",
							"What do you need?",
							"Hey there :)",
							"Hi lovely",
							"Hey :)",
							"I'm all ears",
							"How's your day been?"
		]
		cardView.ratingCardTitle.text = phraseArray[random]
	}
}
// MARK: - Entry page delegate
extension MainViewController: CardViewDelegate {
	
	func hideCard() {
		// TODO: - Hide card here
	}
	
	func editCardButtonTapped() {
		let alertController = UIAlertController(title: "Edit this tracking card", message: nil, preferredStyle: .actionSheet)
		let switchCardAction = UIAlertAction(title: "Switch to a different card", style: .default) { (_) in
			// TODO: - show a list of the cards and then switch to the one picked.
		}
		let addFactorAction = UIAlertAction(title: "Add a factor", style: .default) { (alert) in
			// TODO: - If there are already 3 factors filled I need to ask if user wants to replace one & confirm destruction. Otherwise add one.
			self.createAlert(withPrompt: "Name your factor", message: "", textFieldPlaceholder: "Your most ingenious name.", confirmActionName: "Create", completion: { (input) in
				print("I should create a new factor here")
			})
			
		}
		let deleteFactorAction = UIAlertAction(title: "Delete a factor", style: .destructive) { (alert) in
			// TODO: - I should present an alert action to choose and then to remove a factor and all of it's data here
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
			alertController.dismiss(animated: true, completion: nil)
		}

		alertController.addAction(switchCardAction)
		alertController.addAction(addFactorAction)
		alertController.addAction(deleteFactorAction)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	// Creates an alert controller with specified parameters and returns a string to use on completion.
	func createAlert(withPrompt prompt: String, message: String, textFieldPlaceholder: String, confirmActionName: String, completion: @escaping (String) -> Void){
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
	
	
	func addCardButtonTapped() {
		createAlert(withPrompt: "Create a new card.", message: "What would you like to start tracking?", textFieldPlaceholder: "Card Name", confirmActionName: "Add") { (input) in
			// TODO: - Initialize a new card.
		}
	}
	
	func saveButtonTapped() {
		
		// If any of the buttons are active save the entry
		if cardView.ratingButtons.contains(where: { $0.1 == true }) {
			var rating = 0.0
			rating = cardView.ratingButtons[cardView.mindBadButton]! ? -1.0 : 0.0
			rating = cardView.ratingButtons[cardView.mindGoodButton]! ? 1.0 : 0.0
			EntryController.shared.createEntryWith(mindRating: rating)
			cardView.resetUI()
		} else {
			// If not say no
			cardView.shake()
		}
	}
}
