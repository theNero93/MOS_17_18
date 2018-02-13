//
//  HeartRate.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 31.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class HeartRate {
    private static let KEY_TIME = "time"
    private static let KEY_BPM = "bpm"
    
    var time : Int
    var beatsPerMinute: Int
    
    init(){
        time = 0
        beatsPerMinute = 0
    }
    
    init(time: Int, bpm: Int){
        self.time = time
        self.beatsPerMinute = bpm
    }
    
    init(dict: [String: AnyObject]){
        time = dict[HeartRate.KEY_TIME] as? Int ?? 0
        beatsPerMinute = dict[HeartRate.KEY_BPM] as? Int ?? 0
    }
    
    func dictRep() -> NSDictionary {
        let dict: NSDictionary = [HeartRate.KEY_TIME : time,
                                  HeartRate.KEY_BPM : beatsPerMinute]
        return dict
    }
}
