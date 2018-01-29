//
//  TestSessionViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 29.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import CoreLocation

class TestSessionViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
        seconds = seconds + 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerKilometer)
        
        
        distanceLabel.text = "Distance: \(formattedDistance)"
        timeLabel.text = "Time: \(formattedTime)"
        print("Pace: \(formattedPace)")
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func startRun() {
        seconds = 0
        distance = Measurement(value: 0, unit: .meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func saveSession() {
        let session = Session()
        session.distance = distance.value
        session.duration = seconds
        session.timeStamp = Date()
        
        for location in locationList {
            let locationObj = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude, timeStamp: location.timestamp)
            session.locations.append(locationObj)
        }
    }

    @IBAction func startSession(_ sender: Any) {
        startRun()
    }
    
    @IBAction func stopSession(_ sender: Any) {
        saveSession()
        locationManager.stopUpdatingLocation()
    }
}

extension TestSessionViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else {
                continue
            }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
            locationList.append(newLocation)
        }
    }
}
