//
//  NetworkService.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import CoreLocation
import Alamofire

//MARK:SOURCE
class NetworkService {
    static let shared = NetworkService()
    
    private func getInfoParkings(source: [[String:Any]]) {
        for item in source {
            if let id = item["AhuzotCode"] as? String,
               let lastUpdate = item["LastUpdateFromDambach"] as? String,
               let status = item["InformationToShow"] as? String {
                    let sourceDict : [String : String] = [
                        "id" : id,
                        "lastUpdate" : lastUpdate,
                        "status" : status
                    ]
                    NotificationCenter.default.post(name: NSNotification.Name("getParkInfo"), object: nil, userInfo: sourceDict)
            }
        }
    }
    
    func getInfoOfParkings() {
        let url = "https://api.tel-aviv.gov.il/parking/StationsStatus"
        AF.request(url).responseJSON(completionHandler: { (response) in
            guard let dictValue = response.value as? [[String : Any]] else { return }
            self.getInfoParkings(source: dictValue)
        })
    }
    
    func requestAllParking() {
        let url = "https://api.tel-aviv.gov.il/parking/stations"
        AF.request(url).responseJSON(completionHandler: { [self] (response) in
            guard let dictValue = response.value as? [[String : Any]] else { return }
            self.getParkings(sourceArray: dictValue)
        })
    }
    
    private func getParkings(sourceArray: [[String : Any]]) {
        getSourceOfParkings(sourceArray: sourceArray)
    }
    
    private func getSourceOfParkings(sourceArray: [[String : Any]]) {
        for item in sourceArray {
            if let parkingItem = parseParking(source: item) {
                let sourceDict : [String : Parking] = [
                    "source" : parkingItem
                ]
                NotificationCenter.default.post(name: NSNotification.Name("updateParkSource"), object: nil, userInfo: sourceDict)
            }
        }
        self.getInfoOfParkings()
    }
    
    private func parseParking(source: [String : Any]) -> Parking? {
        if let name = source["Name"] as? String,
           let address = source["Address"] as? String,
           let long = (source["GPSLongitude"] as? NSString)?.floatValue,
           let lat = (source["GPSLattitude"] as? NSString)?.floatValue,
           let descr = source["DaytimeFee"] as? String,
           let comment = source["FeeComments"] as? String,
           let id = source["AhuzotCode"] as? String {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                let item = Parking(name: name, address: address, descr: descr, comment: comment, id: id, location: location)
                return item
        }
        return nil
    }
}
