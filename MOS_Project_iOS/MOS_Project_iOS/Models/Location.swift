//
//  Location.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class Location {
    private static let KEY_LATITUDE = "latitude"
    private static let KEY_LONGITUDE = "longitude"
    private static let KEY_TIMESTAMP = "timestamp"
    
    
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
    
    init(dict: NSDictionary) {
        latitude = dict[Location.KEY_LATITUDE] as? Double ?? 0
        longitude = dict[Location.KEY_LONGITUDE] as? Double ?? 0
        let timeInterval = dict[Location.KEY_TIMESTAMP] as? Double ?? 0
        timeStamp = Date(timeIntervalSince1970: timeInterval)
    }
    
}
