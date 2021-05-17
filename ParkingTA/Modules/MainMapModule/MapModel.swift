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
        guard let location = locationManager.location?.coordinate else { return }
        
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionConst, longitudinalMeters: regionConst)
        map.setRegion(region, animated: true)
    }
    
    //MARK:PERMISSION
    func setDelegates() {
        parkingCV.delegate = self
        parkingCV.dataSource = self
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMap), name: NSNotification.Name("updateMap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNearestParkings), name: NSNotification.Name("sourceDone"), object: nil)
    }
    
    @objc func updateMap() {
        self.updateAnnotations()
    }
    
    func updateAnnotations() {
        map.removeAnnotations(map.annotations)
        
        for item in sourceParkingArray {
            let coordinate = item.location
            
            let annotation = MKPointAnnotation()
            annotation.title = item.name
            annotation.coordinate = coordinate
            
            map.addAnnotation(annotation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let spot = self.selectedSpot,
           let destinationVC = segue.destination as? ReviewSpotViewController {
            destinationVC.reviewSpot = spot
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
        guard let spot = sourceParkingArray.first(where: {$0.name == view.annotation?.title}) else { return }
        
        self.selectedSpot = spot
        self.performSegue(withIdentifier: "reviewSpot", sender: self)
    }
}

//MARK:NEAREST PARKINGS
extension MainMapViewController {
    @objc func getNearestParkings() {
        guard let userLocation = locationManager.location else { return }
        sourceParkingArray.forEach { (parking) in
            let location = CLLocation(latitude: parking.location.latitude, longitude: parking.location.longitude)
            let distance = userLocation.distance(from: location).inKilometers()
            parking.distance = distance
        }
        
        topNearestParkings.removeAll()
        let tempArray = sourceParkingArray.sorted(by: {$0.distance! < $1.distance!})
        topNearestParkings = tempArray
        self.parkingCV.reloadData()
    }
}
