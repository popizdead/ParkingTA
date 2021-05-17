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
    @IBOutlet weak var statusBgView: UIView!
    
    @IBOutlet weak var lastUpdateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var wayButton: UIButton!
    
    var reviewSpot: Parking?
    var isSavedSpot = false
    
    let dataManager = DataManager.shared
    
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
        let viewsBgArray : [UIView] = [nameBgView, descrBgView, commentBgView, statusBgView]
        let vc = MainMapViewController()
        
        for item in viewsBgArray {
            item.backgroundColor = vc.whiteColor
            item.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        }
        
        self.view.backgroundColor = vc.whiteColor
        saveButton.backgroundColor = vc.blueColor
        wayButton.backgroundColor = vc.blueColor
        
        saveButton.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
        wayButton.makeShadowAndRadius(shadow: true, opacity: 0.5, radius: 10)
    }
    
    @objc func updateUI() {
        self.configureLabels()
        self.checkSavedState()
        self.configureButton()
    }
    
    
    //MARK:ACTION
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.buttonAction()
    }
    
    @IBAction func wayButtonTapped(_ sender: UIButton) {
        guard let spot = reviewSpot else { return }
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(spot.location.latitude),\(spot.location.longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
        } else {
            NSLog("Can't use comgooglemaps://");
        }
    }
    
}
