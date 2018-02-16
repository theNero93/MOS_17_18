//
//  SessionDetailViewController.swift
//  MOS_Project_iOS
//
//  Created by solvistas on 30.01.18.
//  Copyright © 2018 fhooe.mc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SessionDetailViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var breathsLabel: UILabel!
    
    @IBOutlet weak var mapDetail: MKMapView!
    
    private var prevViewController: UIViewController?
    private let calcLogic = CalculatorLogic.shared
    private let firebaseHelper = FirebaseHelper.shared
    
    private var userData = UserData()
    
    var session = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
        setupView()
        self.navigationItem.backBarButtonItem?.title = "";
//        self.navigationItem.hidesBackButton = true
    }
    

    
    private func loadUserData() {
        firebaseHelper.getUserData() {(data, completed) in
            if completed {
                self.userData = data!
                self.setupUserNeededView()
            }
            
        }
    }

    private func setupView() {
        mapDetail.delegate = self
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = dateFormatter.string(from: session.timeStamp)
        distance.text = String(session.distance)
        timeLabel.text = String(session.duration)
        
        
        //FAKE all Stuff for now...HR will be added to Session
        
        heartRateLabel.text = String(120)
        caloriesLabel.text = "No Data"
        breathsLabel.text = "No Data"
        
        loadMap()
    }
    
    private func setupUserNeededView(){
        caloriesLabel.text = String(calcLogic.calcCalories(heartRate: 120, userData: userData))
        breathsLabel.text = String(calcLogic.calcBreaths(heartRate: 60, time: session.duration))
    }
    
    
    private func mapRegion() -> MKCoordinateRegion? {
        let locations = session.locations
        guard locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline {
        let locations = session.locations
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func loadMap() {
        let locations = session.locations
        guard locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapDetail.setRegion(region, animated: true)
        mapDetail.add(polyLine())
    }


}

extension SessionDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}
