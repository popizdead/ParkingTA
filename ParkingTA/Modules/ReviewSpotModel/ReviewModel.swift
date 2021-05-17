//
//  ReviewModel.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation

extension ReviewSpotViewController {
    
    //MARK:UI
    func configureLabels() {
        guard let parking = reviewSpot else { self.dismiss(animated: true, completion: nil); return }
        
        self.parkingNameLbl.text = parking.name
        self.addressLbl.text = parking.address
        self.descrLbl.text = parking.descript
        self.commentLbl.text = parking.comment
        
        if parking.lastUpdate != nil,
           parking.status != nil {
                self.statusBgView.isHidden = false
                self.lastUpdateLbl.text = parking.lastUpdate
                self.statusLbl.text = parking.status
        } else {
                self.statusBgView.isHidden = true
        }
    }
    
    func configureButton() {
        switch isSavedSpot {
        case true:
            saveButton.setTitle("למחוק", for: .normal)
        case false:
            saveButton.setTitle("לשמור", for: .normal)
        }
    }
    
    //MARK:STATE
    func checkSavedState() {
        guard let id = reviewSpot?.id else { return }
        self.isSavedSpot = dataManager.userFavoriteArray.contains(id)
    }
    
    func buttonAction() {
        guard let spot = reviewSpot else { return }
        
        if isSavedSpot {
            dataManager.userFavoriteArray = dataManager.userFavoriteArray.filter({$0 != spot.id})
            dataManager.delete(parking: spot)
        } else {
            dataManager.userFavoriteArray.append(spot.id)
            dataManager.save(parking: spot)
        }
        
        isSavedSpot = !isSavedSpot
        reviewSpot?.isSaved = isSavedSpot
        
        NotificationCenter.default.post(name: NSNotification.Name("updateMap"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
