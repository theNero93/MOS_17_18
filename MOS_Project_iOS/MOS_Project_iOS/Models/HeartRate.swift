//
//  HeartRate.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 31.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class HeartRate {
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
}
