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
    @IBOutlet weak var parkingCV: UICollectionView!
    
    var selectedSpot: Parking?
    
    let locationManager = CLLocationManager()
    let regionConst : Double = 10000
    
    let network = NetworkService.shared
    let dataManager = DataManager.shared
    
    var sourceParkingArray : [Parking] = []
    var topNearestParkings : [Parking] = []
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        observes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    //MARK:UI
    private func configureUI() {
        self.parkingCV.backgroundColor = .clear
        self.parkingCV.backgroundView = UIView(frame: .zero)
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

//MARK:COLLECTION VIEW
extension MainMapViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNearestParkings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = parkingCV.dequeueReusableCell(withReuseIdentifier: "parkingCell", for: indexPath) as! ParkingCollectionViewCell
        let parking = topNearestParkings[indexPath.row]
        
        cell.cellParking = parking
        cell.configureUI()
        
        return cell
    }
    
    
}
