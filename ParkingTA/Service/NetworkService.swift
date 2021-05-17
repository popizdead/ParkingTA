//
//  NetworkService.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import MapKit
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
                NotificationCenter.default.post(name: NSNotification.Name("updateParkSource"), object: nil, userInfo: parkingItem.getDictFromParking())
            }
        }
        self.getInfoOfParkings()
        NotificationCenter.default.post(name: NSNotification.Name("sourceDone"), object: nil)
    }
    
    private func parseParking(source: [String : Any]) -> Parking? {
        let manager = DataManager.shared
        
        if let name = source["Name"] as? String,
           let address = source["Address"] as? String,
           let long = (source["GPSLongitude"] as? NSString)?.floatValue,
           let lat = (source["GPSLattitude"] as? NSString)?.floatValue,
           let descr = source["DaytimeFee"] as? String,
           let comment = source["FeeComments"] as? String,
           let id = source["AhuzotCode"] as? String {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
                let item = Parking(name: name, address: address, descr: descr, comment: comment, id: id, location: location)
            
                item.isSaved = manager.userFavoriteArray.contains(where: {$0 == item.id})
            
                return item
        }
        return nil
    }
}

//MARK:MAP VC
extension MainMapViewController {
    @objc func updateArray(_ notification: NSNotification) {
        //MARK:TODO
        
        guard let parking = notification.userInfo?["source"] as? Parking else { return }
        
        if !sourceParkingArray.contains(where: {$0.id == parking.id}) {
            let coordinate = parking.location
            
            let annotation = MKPointAnnotation()
            annotation.title = parking.name
            annotation.coordinate = coordinate
            
            map.addAnnotation(annotation)
            self.sourceParkingArray.append(parking)
        }
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
        
        topNearestParkings.removeAll()
        let tempArray = sourceParkingArray.sorted(by: {$0.distance! < $1.distance!})
        topNearestParkings = tempArray
        self.parkingCV.reloadData()
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
}
