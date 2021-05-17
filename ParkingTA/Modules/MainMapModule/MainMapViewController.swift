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
    let regionConst : Double = 1500
    
    let network = NetworkService.shared
    let dataManager = DataManager.shared
    
    var sourceParkingArray : [Parking] = []
    var topNearestParkings : [Parking] = []
    
    //Colors
    public let blackColor = UIColor(named: "BlackColor")
    public let whiteColor = UIColor(named: "WhiteColor")
    public let blueColor = UIColor(named: "BlueColor")
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let parking = topNearestParkings[indexPath.row]
        let region = MKCoordinateRegion.init(center: parking.location, latitudinalMeters: 500, longitudinalMeters: 500)
        
        map.setRegion(region, animated: true)
    }
}
