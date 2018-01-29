//
//  Session.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class Session {
    var distance: Double
    var duration: Int
    var locations: [Location]
    var timeStamp: Date
    
    init () {
        distance = 0
        duration = 0
        locations = []
        timeStamp = Date()
    }
}

