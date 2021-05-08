//
//  Parking.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import CoreLocation

final class Parking {
    let name : String
    let address : String
    let descript : String
    let comment : String
    
    let location : CLLocationCoordinate2D
    
    init(name: String, address: String, descr: String, comment: String, location: CLLocationCoordinate2D) {
        self.address = address
        self.name = name
        self.comment = comment
        self.descript = descr
        self.location = location
    }
}
