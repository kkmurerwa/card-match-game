//
//  CardModel.swift
//  Match App
//
//  Created by Kenneth Murerwa on 22/06/2022.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Declare an array to store numbers already generated
        var generatedNumbersArray = [Int]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            // Make it so we only have unique pairs of cards
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the random number
                print(randomNumber)
                
                // Store the number into the generated numbers array
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
            
            
        }
        
        // Randomize the array
        for i in 0...generatedCardsArray.count - 1 {
            
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    }
    
}
