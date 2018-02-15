//
//  Session.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Session {
    private static let KEY_DISTANCE = "distance"
    private static let KEY_DURATION = "duration"
    private static let KEY_TIMESTAMP = "timestamp"
    static let KEY_LOCATIONS = "locations"
    static let KEY_HEARTRATE = "heartrate"
    
    
    
    var distance: Double
    var duration: Int
    var locations: [Location]
    var heartRate: [HeartRate]
    var timeStamp: Date
    
    init () {
        distance = 0
        duration = 0
        locations = []
        heartRate = []
        timeStamp = Date()
    }
    
    init(dict: NSDictionary){
        distance = dict[Session.KEY_DISTANCE] as? Double ?? 0
        duration = dict[Session.KEY_DURATION] as? Int ?? 0
        let timeInterval: TimeInterval = dict[Session.KEY_TIMESTAMP] as? Double ?? 0
        timeStamp = Date(timeIntervalSince1970: timeInterval)
        locations = [Location]()
        heartRate = []
    }
    
    init(any: [String: AnyObject]){
        distance = any[Session.KEY_DISTANCE] as? Double ?? 0
        duration = any[Session.KEY_DURATION] as? Int ?? 0
        let timeInterval: TimeInterval = any[Session.KEY_TIMESTAMP] as? Double ?? 0
        timeStamp = Date(timeIntervalSince1970: timeInterval)
        locations = []
        heartRate = []
        if let locationDict = any[Session.KEY_LOCATIONS] as? [String:AnyObject] {
            for loc in locationDict {
                if let locDict = loc.value as? [String:AnyObject] {
                    locations.append(Location(dict: locDict))
                }
                
            }
        }
        if let heartrateDict = any[Session.KEY_HEARTRATE] as? [String:AnyObject] {
            for hr in heartrateDict {
                if let hrDict = hr.value as? [String:AnyObject] {
                    heartRate.append(HeartRate(dict: hrDict))
                }
            }
        }
        
        
 
    }
    
    
    func dictRep()->NSDictionary {
        let dict: NSDictionary = [Session.KEY_DISTANCE : distance,
                                  Session.KEY_DURATION : duration,
                                  Session.KEY_TIMESTAMP : timeStamp.timeIntervalSince1970]
        return dict
    }
    

}

