//
//  ParkingCollectionViewCell.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 17/05/2021.
//

import UIKit

class ParkingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var addresLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var cellParking: Parking?
    
    func configureUI() {
        guard let spot = cellParking else { return }
        guard let distance = spot.distance else { return }
        
        self.stateLbl.text = spot.status
        self.nameLbl.text = spot.name
        self.distanceLbl.text = String().getDisctanceFormat(value: distance)
        self.addresLbl.text = spot.address
        
        self.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.contentView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        self.bgView.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        
        fillColors()
    }
    
    private func fillColors() {
        let lblsArray : [UILabel] = [stateLbl, nameLbl, distanceLbl, addresLbl]
        let vc = MainMapViewController()
        
        for lbl in lblsArray {
            lbl.textColor = vc.blackColor
        }
        
        bgView.backgroundColor = vc.whiteColor
    }
}
