//
//  Location.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class Location {
    var latitude: Double
    var longitude: Double
    var timeStamp: Date
    
    init(lat: Double, long: Double, timeStamp: Date) {
        latitude = lat
        longitude = long
        self.timeStamp = timeStamp
    }
    init(){
        latitude = 0
        longitude = 0
        timeStamp = Date()
    }
    
}
