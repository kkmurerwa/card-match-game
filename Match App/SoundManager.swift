//
//  SoundManager.swift
//  Match App
//
//  Created by Kenneth Murerwa on 23/06/2022.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect: SoundEffect) {
        
        var soundFileName = ""
        
        // Determine which sound effect to play and match it with its filename
        switch effect {
            
            case .flip:
                soundFileName = "cardflip"
            
            case .shuffle:
                soundFileName = "shuffle"
            
            case .match:
                soundFileName = "dingcorrect"
            
            case .nomatch:
                soundFileName = "dingwrong"
        }
        
        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find the sound filename")
            
            return
        }
        
        // Create a URL object from this string path
        let soundUrl = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            
            // Play the sound
            audioPlayer?.play()
        } catch {
            
            // Couldn't create audio player object, log the error
            print("Couldn't create the audio player object for the sound file \(soundFileName)")
        }
    }
    
}
