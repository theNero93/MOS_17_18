//
//  PaceViewController.swift
//  PaceApp
//
//  Created by Nora Isabel Wokatsch on 15.02.18.
//  Copyright © 2018 Nora Isabel Wokatsch. All rights reserved.
//

import CoreBluetooth
import UIKit

class PaceViewController: UIViewController {

    //Constants
    let SIMBLEE_UUID = CBUUID(string: "1234")
    let STEPS_UUID = CBUUID(string: "2D30C082-F39F-4CE6-923F-3484EA480596")
    let READABLE_CHAR_UUID = "2D30C082-F39F-4CE6-923F-3484EA480596"
    let WRITEABLE_CHAR_UUID = "2D30C083-F39F-4CE6-923F-3484EA480596"
    
    struct Identifier {
        static let FRONT_LEFT_DEVICE = "frle1"
        
        static let SERVICE_UUID = "1234"
        
        static let CHAR_READ = "2D30C082-F39F-4CE6-923F-3484EA480596"
        static let CHAR_WRITE = "2D30C083-F39F-4CE6-923F-3484EA480596"
        static let CHAR_ID_3 = "2D30C084-F39F-4CE6-923F-3484EA480596"
        
        static let SENSOR_DATA_POS = 1
    }

    //booleans
    var isConnected = false // 0: disconnected, 1: connected
    var stepCounter = 0;
    
    //BLE Objects
    var centralManager: CBCentralManager!
    var stepDetecterPeripheral: CBPeripheral!
    var writeCHAR: CBCharacteristic!
    var connectTimer: Timer!
    var updateRSSITimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isConnected = false
        // create central manager for BLE communication
        centralManager = CBCentralManager(delegate: self, queue: nil)
        self.stepCounter = 0;
    }
    
    //UIObjects
    @IBOutlet weak var value_label: UILabel!
    
    @IBAction func btn_scan(_ sender: Any) {
        let services = [CBUUID(string: Identifier.SERVICE_UUID)]
        centralManager.scanForPeripherals(withServices: services, options: nil)
        
        print("BLE scan started")
    }
    
}

extension PaceViewController : CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        isConnected = true
        updateRSSI()
        //set timer to update rssi every second
        updateRSSITimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateRSSI), userInfo: nil, repeats: true)
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Error connecting: \(String(describing: error))")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral)")
        isConnected = false
        stepDetecterPeripheral = nil
        
        if updateRSSITimer.isValid {
            updateRSSITimer.invalidate()
            updateRSSITimer = nil
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let name = peripheral.name else { return }
        //to eliminate my macbook
        if !(name.contains("Noras")) {
            print("Found a Simblee device: \(name), RSSI: \(RSSI)")
            
            if (name == Identifier.FRONT_LEFT_DEVICE) {
                stepDetecterPeripheral = peripheral
                stepDetecterPeripheral.delegate = self
                centralManager.connect(stepDetecterPeripheral)
            }
            
            centralManager.stopScan()
        }
    }
    
    // method called whever the device state changes
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
        //most interesting case
        case .poweredOn:
            print("central.state is .poweredOn")
            let services = [SIMBLEE_UUID]
            centralManager.scanForPeripherals(withServices: services)
        }
    }
    
    @objc func updateRSSI() {
        stepDetecterPeripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("point on RSSI: \(RSSI)")
    }
}

extension PaceViewController : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Discovered service: \(service.uuid)")
            if service.uuid == CBUUID(string: Identifier.SERVICE_UUID) {
                print("TRUE!!!")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Invoked when you discover the characteristics of a specified service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: Identifier.CHAR_READ) {
                stepDetecterPeripheral.setNotifyValue(true, for: characteristic)
            }
            
            if characteristic.uuid == CBUUID(string: Identifier.CHAR_WRITE) {
                writeCHAR = characteristic
            }
        }
        

    }
    
    // Invoked when retrieve a specified characteristic's value, or peripheral notifies app that characteristic value changed
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {return}
        
        if characteristic.uuid == CBUUID(string: Identifier.CHAR_READ) {
            displaySensorData(data: data)
        }
        
    }
    
    func displaySensorData(data : Data) {
        // extract the data
        let dataArray = [UInt8](data)

        // get value of of the element
        let raw = dataArray[Identifier.SENSOR_DATA_POS]
    
        // print
        let val = Int(raw)
        print("GOT SOME RAW: \(raw)")
        print("GOT SOME STUFF: \(val)")
        stepCounter = stepCounter + 1;
        
        value_label.text = "\(stepCounter)"
    }
    
    private func footNumber(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value,
            let byte = characteristicData.first else { return "Error" }
        
        switch byte {
        case 0: return "One"
        case 1: return "Two"
        case 2: return "Three"
        case 3: return "Four"
        case 4: return "Five"
        case 5: return "Six"
        case 6: return "Seven"
        default:
            return "Reserved for future use"
        }
    }
}
