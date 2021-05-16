//
//  DataService.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 16/05/2021.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    static let shared = DataManager()
    
    var userFavoriteArray : [String] = []
    
    func delete(parking: Parking) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<ParkingItem> = ParkingItem.fetchRequest()
        
        if let savedArray = try? context.fetch(fetchRequest) {
            for parkingElement in savedArray {
                if parkingElement.id == parking.id {
                    context.delete(parkingElement)
                }
            }
        }
        
        do { try
            context.save()
        }
        catch {}
    }

    func save(parking: Parking) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ParkingItem", in: context) else { return }
        let spotObject = ParkingItem(entity: entity, insertInto: context)
        spotObject.id = parking.id
        
        do { try
            context.save()
        }
        catch {}
    }

    func fetchSaved() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<ParkingItem> = ParkingItem.fetchRequest()
        
        do {
            
            let savedArray = try context.fetch(fetchRequest)
            userFavoriteArray.removeAll()
            
            for stockElement in savedArray {
                if let id = stockElement.id {
                    userFavoriteArray.append(id)
                }
            }
            
        } catch {}
    }
    
}
