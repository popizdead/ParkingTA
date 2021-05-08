//
//  ReviewSpotViewController.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import UIKit

class ReviewSpotViewController: UIViewController {
    
    //MARK:OUTLETS
    @IBOutlet weak var parkingNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descrLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var nameBgView: UIView!
    @IBOutlet weak var descrBgView: UIView!
    @IBOutlet weak var commentBgView: UIView!
    
    var reviewSpot: Parking?
    
    //MARK:VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    //MARK:UI
    private func configureUI() {
        let viewsBgArray : [UIView] = [nameBgView, descrBgView, commentBgView]
        
        for item in viewsBgArray {
            item.backgroundColor = .white
            item.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        }
    }
    
    private func updateUI() {
        guard let parking = reviewSpot else { return }
        
        self.parkingNameLbl.text = parking.name
        self.addressLbl.text = parking.address
        self.descrLbl.text = parking.descript
        self.commentLbl.text = parking.comment
    }

}
