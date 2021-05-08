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
    
    let locationManager = CLLocationManager()
    let regionConst : Double = 10000
    
    let network = NetworkService.shared
    var sourceParkingArray : [Parking] = []
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        checkPermission()
        observes()
    }
}
