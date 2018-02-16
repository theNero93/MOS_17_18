//
//  CalculatorLogic.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 31.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation

class CalculatorLogic {
    static let shared = CalculatorLogic()
    
    
    private init(){
        
    }
    
    
    func calcCalories(heartRate: Int, userData: UserData)->Int {
        let vo2 = calculateVO2(userData: userData)
        print("VO2: \(vo2)")
        let maleGen =  Double(userData.genderData())
        let maleAge = -36.3781 + 0.271 * Double(userData.age)
        let maleWeight = 0.394 * Double(userData.weight)
        let maleHeartRate = 0.404 * vo2 * 0.643 * Double(heartRate)
        let femaleGen = Double(1 - userData.genderData())
        let femaleAge = 0.274 * Double(userData.age)
        let femaleWeight = 0.103 * Double(userData.weight)
        let femaleHeartRate = 0.380 * vo2 * 0.450 * Double(heartRate)
        
        let female = femaleGen * (femaleAge + femaleWeight + femaleHeartRate)
        let male = maleGen * (maleAge + maleWeight + maleHeartRate)
        let ee =  -59.3954 + male + female
        return joulToCal(ee: ee)
    }
    
    private func calculateVO2(userData: UserData) -> Double{
        let pa = Double(7)
        let vo2Age = (0.133 * Double(userData.age)) - (0.005 * Double(userData.age) *
            Double(userData.age))
        let vo2Gender: Double = (11.403 * Double(userData.genderData()))
        let vo2Pa: Double = (1.463 * pa)
        let vo2Hight: Double = (9.17 * Double(userData.size/100))
        let vo2Mass = (0.254 * Double(userData.weight))
        let vo2 = vo2Age + vo2Gender + vo2Pa + vo2Hight - vo2Mass + 34.143
        return vo2
    }
    
    private func joulToCal(ee: Double) -> Int{
        return Int(ee/4.168)
        
    }
    
    func calcBreaths(heartRate: Int, time: Int) -> Int {
        return 50
    }
    
}
