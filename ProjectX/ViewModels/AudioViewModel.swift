//
//  HapticViewModel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import AVFoundation
import Foundation

class AudioViewModel {
    static let shared = AudioViewModel()
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            Helpers.debugLog("Sound Not Found: \(fileName)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch let error {
            Helpers.debugLog("playSound: \(error)")
        }
    }
}
