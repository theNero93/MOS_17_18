//
//  MenuViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 11.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var testPedometer: UILabel!
    let pedometerLogic = PedometerLogic.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true


        // Do any additional setup after loading the view.
    }

    
    private func getStepsToday(){
        pedometerLogic.startCountingSteps(){ (pedometerData, error) in
            guard let pedometerData = pedometerData, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.testPedometer.text = pedometerData.numberOfSteps.stringValue
            }
            
        }
    }

}
