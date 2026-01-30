//
//  HapticViewModel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

class AudioViewModel: ObservableObject {
    static let shared = AudioViewModel()
    
    private var audioPlayer: AVAudioPlayer?
    private let speechSynth = AVSpeechSynthesizer()
    
    @AppStorage("speechRate") var speechRate: Double = 0.5 // Speed (0.0 - 1.0)
    @AppStorage("speechPitch") var speechPitch: Double = 1.0 // Pitch (0.5 - 2.0)
    
    func speakText(_ text: String, language: String = "en-US") {
        let utterance = AVSpeechUtterance(string: text)
        
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = Float(speechRate)
        utterance.pitchMultiplier = Float(speechPitch)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            speechSynth.speak(utterance)
        } catch let error {
            Helpers.debugLog("speakText: \(error)")
        }
    }
    
    func playSound(_ name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            Helpers.debugLog("Sound Not Found: \(name)")
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
