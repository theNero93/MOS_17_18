//
//  PedometerViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import FirebaseAuth

class PedometerViewController: UIViewController {

    @IBOutlet weak var stepsTodayLabel: UILabel!
    @IBOutlet weak var stepsGoalLabel: UILabel!
    @IBOutlet weak var stepsHighscoreLabel: UILabel!
    @IBOutlet weak var stepsThisYearLabel: UILabel!
    
    let pedometerLogic = PedometerLogic.shared
    let firebaseHelper = FirebaseHelper.shared
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupStepsToday()
        setupStepsGoal()
        setupStepsHighscore()
        setupStepsThisYear()
    }
    
    
    private func setupStepsToday() {
        let endDate = Date()
        let startDate = Date().startOfCurrentDay()
        pedometerLogic.getSteps(from: startDate, to: endDate) {(data, error) in
            guard let pedometerData = data, error == nil else {
                print("Something went Wrong while getting todays steps")
                DispatchQueue.main.async {
                    self.stepsTodayLabel.text = "No Data!"
                }
                return
            }
            DispatchQueue.main.async {
                self.stepsTodayLabel.text = pedometerData.numberOfSteps.stringValue
            }
        }
    }
    
    private func setupStepsGoal() {
        firebaseHelper.getUserData() {(data, completed) in
            if completed {
                self.stepsGoalLabel.text = String(data!.stepGoal)
            }
            
        }
        
    }
    
    private func setupStepsHighscore() {

        firebaseHelper.getUserData() {(data, completed) in
            if completed {
                self.stepsHighscoreLabel.text = String(data!.stepHighScore)
            }
            
        }
    }
    
    private func setupStepsThisYear(){
        let endDate = Date()
        let startDate = Date().startOfYear()
        pedometerLogic.getSteps(from: startDate, to: endDate) {(data, error) in
            guard let pedometerData = data, error == nil else {
                print("Something went Wrong while getting years steps")
                DispatchQueue.main.async {
                    self.stepsTodayLabel.text = "No Data!"
                }
                return
            }
            DispatchQueue.main.async {
                self.stepsTodayLabel.text = pedometerData.numberOfSteps.stringValue
            }
        }
    }

}
