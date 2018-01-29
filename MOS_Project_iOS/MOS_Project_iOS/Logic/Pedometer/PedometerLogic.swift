//
//  PedometerLogic.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 12.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import Foundation
import CoreMotion

class PedometerLogic {
    static let shared = PedometerLogic.init()
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    func startTrackingActivityType(completion: @escaping (CMMotionActivity?)-> Void) {
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            completion(activity)
        }
    }
    
    func startCountingSteps(completion: @escaping (CMPedometerData?, Error?) -> Void) {
        pedometer.startUpdates(from: Date()) { pedometerData, error in
            completion(pedometerData, error)
        }
    }
    
    
}

