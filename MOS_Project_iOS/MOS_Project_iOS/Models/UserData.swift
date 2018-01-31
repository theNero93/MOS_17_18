//
//  UserData.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation


class UserData {
    private let KEY_FIRSTNAME = "firstName"
    private let KEY_LASTNAME = "lastName"
    private let KEY_AGE = "age"
    private let KEY_SEX = "sex"
    private let KEY_SIZE = "size"
    private let KEY_WEIGHT = "weight"
    private let KEY_STEPGOAL = "stepgoal"
    private let KEY_STEPHIGHSCORE = "stephighscore"
    
    
    
    var firstName: String
    var lastName: String
    var age: Int
    var sex: String
    var size: Int
    var weight: Int
    var stepGoal: Int
    var stepHighScore: Int
    
    
    init () {
        firstName = ""
        lastName = ""
        age = 0
        sex = ""
        size = 0
        weight = 0
        stepGoal = 0
        stepHighScore = 0
    }
    
    init (json: [String: Any]) {
        firstName = json[KEY_FIRSTNAME] as! String
        lastName = json[KEY_LASTNAME] as! String
        age = json [KEY_AGE] as! Int
        sex = json[KEY_SEX] as! String
        size = json[KEY_SIZE] as! Int
        weight = json[KEY_WEIGHT] as! Int
        stepGoal = json[KEY_STEPGOAL] as! Int
        stepHighScore = json[KEY_STEPHIGHSCORE] as! Int
    }
    
    func jsonRep() -> [String: Any] {
        let json : [String: Any] = [KEY_FIRSTNAME : firstName,
                    KEY_LASTNAME : lastName,
                    KEY_AGE : age,
                    KEY_SEX : sex,
                    KEY_SIZE : size,
                    KEY_WEIGHT : weight,
                    KEY_STEPGOAL : stepGoal,
                    KEY_STEPHIGHSCORE : stepHighScore]
        return json
    }
    

}
