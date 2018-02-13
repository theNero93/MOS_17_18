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
        let vo2 = Double(55.4)
        /*let female = -59.3954 + userData.genderData() * (-36.3781 + 0.271 * userData.age + 0.394 * userData.weight + 0.404 * vo2 * 0.643 * heartRate)
        let male = (1 - userData.genderData()) * (0.274 * userData.age + 0.103 * userData.weight + 0.380 * vo2 * 0.450 * heartRate)
        let ee =  male + female*/
        let ee = 1232
        return ee
    }
    
    func calcBreaths(heartRate: Int, time: Int) -> Int {
        return 50
    }
    
}
