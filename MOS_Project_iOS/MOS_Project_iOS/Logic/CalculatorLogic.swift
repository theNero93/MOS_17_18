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
    
    
    func calcCalories(heartRate: Int)->Int{
        return 1500
    }
    
    func calcBreaths(placeholder: Int) -> Int {
        return 35
    }
    
}
