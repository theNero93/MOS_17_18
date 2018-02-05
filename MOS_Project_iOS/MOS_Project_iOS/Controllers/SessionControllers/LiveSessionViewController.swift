//
//  LiveSessionViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LiveSessionViewController: UIViewController {
    
    //border color
    var borderColor = UIColor(red:0.00, green:0.47, blue:0.60, alpha:1.0)

    @IBOutlet weak var timeSessionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beatsPerMinutesLabel: UILabel!
    @IBOutlet weak var breathsPerMinuteLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var myMap: MKMapView!
    //PLACEHOLDER (Zu müde für herumspielerrei mit bar button item sorry)
    @IBOutlet weak var startStopButton: UIButton!
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    private var isStart = true
    
    private var mySession = Session()
    
    private let toDetailSegueIdentifer = "toSessionDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        self.navigationItem.hidesBackButton = false
        
        //start stop button border color
        self.startStopButton.layer.borderColor = self.borderColor.cgColor
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
        let formattedDistance = round(distance.value)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.metersPerSecond)
        
        timeSessionLabel.text = "\(formattedTime)"
        distanceLabel.text = "\(formattedDistance) m"
        paceLabel.text = "\(formattedPace)"
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func startRun() {
        self.navigationItem.hidesBackButton = true
        startStopButton.setTitle("Stop", for: .normal)
        isStart = false
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
        mySession.distance = distance.value
        mySession.duration = seconds
        mySession.timeStamp = Date()
        
        for location in locationList {
            let locationObj = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude, timeStamp: location.timestamp)
            mySession.locations.append(locationObj)
        }
        
        
        timer?.invalidate()
        
        //stop Session
        
        //save to DB
    }

    @IBAction func startStopAction(_ sender: Any) {
        if isStart {
            startRun()
        }else {
            let alertController = UIAlertController(title: "End run?",
                                                    message: "Do you wish to end your run?",
                                                    preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.saveSession()
                self.performSegue(withIdentifier: self.toDetailSegueIdentifer, sender: nil)
            })
            present(alertController, animated: true)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case toDetailSegueIdentifer:
            guard let sessionDetailViewController = segue.destination as? SessionDetailViewController else {
                print("Not a Session Detail View Controller")
                return
            }
            sessionDetailViewController.session = mySession
        default:
            break
        }
    }
}

extension LiveSessionViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else {
                continue
            }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                myMap.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                myMap.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

extension LiveSessionViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
