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
    
    func checkLocationAuth() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapConfigure()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
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
                parking.lastUpdate = convertDate(string: lastUpdate)
                parking.status = status
            }
        }
    }
    
    private func convertDate(string: String) -> String {
        let df = DateFormatter()
        var tempString = ""
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        
        if let date = df.date(from: string) {
            df.dateFormat = "HH:mm:ss dd/MM"
            tempString = df.string(from: date)
        }
        
        return tempString
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
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotation")
        
        guard let annotationSpot = sourceParkingArray.first(where: {$0.name == annotation.title}) else { return annotationView }
        if dataManager.userFavoriteArray.contains(annotationSpot.id) {
            annotationView.image = UIImage(named: "fav")
        } else {
            annotationView.image = UIImage(named: "parkingIcon")
        }
        
        annotationView.canShowCallout = true
        return annotationView
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
