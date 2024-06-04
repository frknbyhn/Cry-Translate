//
//  MeditationModel.swift
//  PulseMonitor
//
//  Created by Furkan BEYHAN on 10.04.2023.
//

import Foundation

struct SavedMeditModel : Codable {
    
    var id : String?
    
    var isFirstPlaying : Bool?
    var isSecondPlaying : Bool?
    var isThirdPlaying : Bool?
    var isFourthPlaying : Bool?
    var isFifthPlaying : Bool?
    var isSixthPlaying : Bool?
    var isSevenPlaying : Bool?
    var isEightPlaying : Bool?
    
    var firstVol : Float?
    var secondVol : Float?
    var thirdVol : Float?
    var fourthVol : Float?
    var fifthVol : Float?
    var sixthVol : Float?
    var sevenVol : Float?
    var eightVol : Float?
    
}
