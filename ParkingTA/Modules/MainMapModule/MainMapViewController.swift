//
//  MainMapViewController.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController {
    
    //MARK:OUTLETS
    @IBOutlet weak var map: MKMapView!
    var selectedSpot: Parking?
    
    let locationManager = CLLocationManager()
    let regionConst : Double = 10000
    
    let network = NetworkService.shared
    let dataManager = DataManager.shared
    
    var sourceParkingArray : [Parking] = []
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        checkPermission()
        observes()
        
    }
    
    //MARK:DELEGATES
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionConst, longitudinalMeters: regionConst)
        map.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()
    }
}
