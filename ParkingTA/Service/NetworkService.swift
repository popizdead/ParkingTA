//
//  NetworkService.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import CoreLocation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    func requestAllParking() {
        let url = "https://api.tel-aviv.gov.il/parking/stations"
        AF.request(url).responseJSON(completionHandler: { [self] (response) in
            guard let dictValue = response.value as? [[String : Any]] else { return }
            self.parseDict(sourceArray: dictValue)
        })
    }
    
    private func parseDict(sourceArray: [[String : Any]]) {
        for item in sourceArray {
            if let parkingItem = parseParking(source: item) {
                let sourceDict : [String : Parking] = [
                    "source" : parkingItem
                ]
                NotificationCenter.default.post(name: NSNotification.Name("updateParkSource"), object: nil, userInfo: sourceDict)
            }
        }
    }
    
    private func parseParking(source: [String : Any]) -> Parking? {
        if let name = source["Name"] as? String,
           let address = source["Address"] as? String,
           let long = (source["GPSLongitude"] as? NSString)?.floatValue,
           let lat = (source["GPSLattitude"] as? NSString)?.floatValue,
           let descr = source["DaytimeFee"] as? String,
           let comment = source["FeeComments"] as? String {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                let item = Parking(name: name, address: address, descr: descr, comment: comment, location: location)
                return item
        }
        return nil
    }
}
