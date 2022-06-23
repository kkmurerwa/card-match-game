//
//  ViewController.swift
//  Match App
//
//  Created by Kenneth Murerwa on 22/06/2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var milliseconds: Float = 30 * 1000 // 20 seconds
    
//    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the view controller as the delegate and data source for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Call the getCards method of the CardModel
        cardArray = model.getCards()
        
        // Create timer instance
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        // Add timer to run loop to prevent it from being paused when a user scrolls through the collection view
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        SoundManager.playSound(.shuffle)
    }

    // MARK: - Timer Methods
    @objc func timerElapsed() {
        
        // Reduce final time
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label value
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // Stop timer at zero
        if milliseconds <= 0 {
            // Stop the timer
            timer?.invalidate()
            
            // Change timer text color to red
            timerLabel.textColor = UIColor.red
            
            // Check if there are any unmathed methods
            checkGameEnded()
        }
    }
    
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set the card for the cell
        cell.setCard(card)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if any time left
        if milliseconds <= 0 {
            return
        }
        
        // Get the cell selected by user
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card selected by user
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false {
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            // Flip the card
            cell.flip()
            
            // Set cardIsFlipped to true
            card.isFlipped = true
            
            //Determine if it's the first or second card flipped over
            if firstFlippedCardIndex == nil {
                
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath
            } else {
                
                // This is the second card being flipped
                
                
                // Perform matching logic
                checkForMatches(indexPath)
            }
            
        }
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
        } else {
            
            // No match
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip the cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionview to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            
            // Reload card at given index
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the value of the first flipped card
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        // Determine if there are any cards unmatched
        var hasWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                hasWon = false
                break
            }
            
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        // Stop timer if user has won
        if hasWon {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
            
        } else {
            
            // If there are unmatched cards, check if there are any left
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title: title, message: message)
        
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

