//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Kenneth Murerwa on 22/06/2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ passedCard: Card) {
        
        // Assign card value to global card variable
        self.card = passedCard
        
        // Set front imageview to card value
        frontImageView.image = UIImage(named: passedCard.imageName)
        
        if passedCard.isMatched == true {
            
            // If the card has been matched make the imageviews invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        } else {
            
            // If the card hasn't been matched make the imageviews visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        // Determine if the card is in a flipped up state or down state
        if passedCard.isFlipped == true {
            
            // Make sure the frontImageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        } else {
            
            // Make sure the backImageView is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)

        }
        
    }
    
    func flip() {
        
        // Add transition to show the front imageview
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        // Delay the flipping by 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            // Add transition to show the back imageview
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        })
        
    }
    
    func remove() {
        
        // Removes both imageviews from being visible by setting alpha to zero
        backImageView.alpha = 0
        
        // Animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
    
}
