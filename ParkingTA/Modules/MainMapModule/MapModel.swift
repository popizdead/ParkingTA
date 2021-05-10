//
//  MapModel.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import CoreLocation
import MapKit

extension MainMapViewController: CLLocationManagerDelegate {
    //MARK: CONFIGURE
    private func mapConfigure() {
        map.showsUserLocation = true
        centerUserLocation()
        locationManager.startUpdatingLocation()
        network.requestAllParking()
    }
    
    private func centerUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionConst, longitudinalMeters: regionConst)
            map.setRegion(region, animated: true)
        }
    }
    
    //MARK:PERMISSION
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationDelegate()
            checkLocationAuth()
        }
    }
    
    private func setupLocationDelegate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        map.delegate = self
    }
    
    private func checkLocationAuth() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapConfigure()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
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

extension MainMapViewController {
    //MARK:OBSERVES
    func observes() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateArray(_:)), name: NSNotification.Name("updateParkSource"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getParkInfo(_:)), name: NSNotification.Name("getParkInfo"), object: nil)
    }
    
    @objc func updateArray(_ notification: NSNotification) {
        guard let parking = notification.userInfo?["source"] as? Parking else { return }
        let coordinate = parking.location
        
        let annotation = MKPointAnnotation()
        annotation.title = parking.name
        annotation.coordinate = coordinate
        
        map.addAnnotation(annotation)
        self.sourceParkingArray.append(parking)
    }
    
    @objc func getParkInfo(_ notification: NSNotification) {
        guard let id = notification.userInfo?["id"] as? String else { return }
        guard let lastUpdate = notification.userInfo?["lastUpdate"] as? String else { return }
        guard let status = notification.userInfo?["status"] as? String else { return }
        
        self.sourceParkingArray.forEach { (parking) in
            if parking.id == id {
                parking.lastUpdate = lastUpdate
                parking.status = status
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tempSpot = self.selectedSpot {
            let destinationVC = segue.destination as! ReviewSpotViewController
            destinationVC.reviewSpot = tempSpot
        }
    }
}

//MARK:ANNOTATION
extension MainMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        sourceParkingArray.forEach { (spot) in
            if spot.name == view.annotation?.title {
                self.selectedSpot = spot
                self.performSegue(withIdentifier: "reviewSpot", sender: self)
            }
        }
    }
}
