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
import CoreBluetooth

class LiveSessionViewController: UIViewController {
    
    //border color
    var borderColor = UIColor(red:0.00, green:0.47, blue:0.60, alpha:1.0)

    @IBOutlet weak var timeSessionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var beatsPerMinutesLabel: UILabel!
    @IBOutlet weak var breathsPerMinuteLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var startStopButton: UIButton!
    
    private let locationManager = LocationManager.shared
    private let firebaseHelper = FirebaseHelper.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var heartRateList: [HeartRate] = []
    
    private var isStart = true
    
    private var mySession = Session()
    
    private let toDetailSegueIdentifer = "toSessionDetailSegue"
    
    
    //BlueTooth + Heart Rate
    var centralManager: CBCentralManager!
    let heartRateServiceCBUUID = CBUUID(string: "0x180D") //only HRM Devices
    
    //UUIDs for Heart Rate and BodySensorLocation
    let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
    let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
    
    var heartRatePeripheral: CBPeripheral!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        self.navigationItem.hidesBackButton = false
        centralManager = CBCentralManager(delegate: self, queue: nil)

        
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
        /*
        let formattedDistance = round(distance.value)
        */
        let formattedDistance = FormatDisplay.distance(distance)

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
        
        mySession.heartRate = heartRateList
        
        
        timer?.invalidate()
        
        //stop Session
        
        if firebaseHelper.saveSession(session: mySession){
            print("Session Saved Successfully")
        }else {
            print("Session not Saved")
        }
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

extension LiveSessionViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        heartRatePeripheral = peripheral
        heartRatePeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(heartRatePeripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
    }
    
    
}

extension LiveSessionViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            //print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case bodySensorLocationCharacteristicCBUUID:
            let bodySensorLocation = bodyLocation(from: characteristic)
            print(bodySensorLocation)
        case heartRateMeasurementCharacteristicCBUUID:
            let bpm = heartRate(from: characteristic)
            onHeartRateReceived(bpm: bpm)
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    
    private func bodyLocation(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
            let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "Other"
        case 1: return "Chest"
        case 2: return "Wrist"
        case 3: return "Finger"
        case 4: return "Hand"
        case 5: return "Ear Lobe"
        case 6: return "Foot"
        default:
            return "Reserved for future use"
        }
    }
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        let firstBitValue = byteArray[0] & 0x01
        if firstBitValue == 0 {
            // Heart Rate Value Format is in the 2nd byte
            return Int(byteArray[1])
        } else {
            // Heart Rate Value Format is in the 2nd and 3rd bytes
            return (Int(byteArray[1]) << 8) + Int(byteArray[2])
        }
    }
    private func onHeartRateReceived(bpm: Int) {
        heartRateList.append(HeartRate(time: seconds, bpm: bpm))
        self.beatsPerMinutesLabel.text = String(bpm)
    }
}
