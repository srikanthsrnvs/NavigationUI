//
//  TextToSpeech.swift
//  ShadowDelivery
//
//  Created by dEEEP on 24/08/17.
//  Copyright © 2017 Thabresh. All rights reserved.
//

import Foundation

import AVFoundation

class TextToSpeech: NSObject {
  let string = ""
  var utterance:AVSpeechUtterance!
  var synthesizer: AVSpeechSynthesizer!
  
  class var sharedInstance: TextToSpeech {
    struct Singleton {
      static let instance = TextToSpeech()
    }
    return Singleton.instance
  }



  
override init() {
    self.synthesizer = AVSpeechSynthesizer()
     }

  func triggerAudioWithText(speechText:String) {
    self.utterance = AVSpeechUtterance(string: speechText)
    self.utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    synthesizer.speak(utterance)
   // synthesizer.pauseSpeaking(at: .word)

  }
}


