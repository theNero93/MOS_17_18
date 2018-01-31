//
//  HeraklesExtansions.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 29.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

extension Date {
    func startOfCurrentDay() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return gregorian.date(from: components)!
    }
    func endOfCurrentDay() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return gregorian.date(from: components)!
    }
    func nowMinusOne() -> Date {
        let now = Date()
        let nowMinute = now.addingTimeInterval(-10)
        return nowMinute
    }
    
    
    func startOfYear() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return gregorian.date(from: components)!
    }
}



