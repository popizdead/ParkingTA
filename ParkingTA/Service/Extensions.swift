//
//  Extensions.swift
//  ParkingTA
//
//  Created by Даниил Дорожкин on 08/05/2021.
//

import Foundation
import CoreLocation
import UIKit

extension UIView {
    func makeShadowAndRadius(shadow: Bool, opacity: Float, radius: Float) {
        if shadow {
            self.layer.shadowColor = UIColor(named: "ShadowColor")?.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 5
            self.layer.masksToBounds = false
        }
        self.layer.cornerRadius = CGFloat(radius)
    }
}

extension CLLocationDistance {
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}

extension String {
    func getDisctanceFormat(value: Double) -> String {
        return String(format: "%.2f קמ", value)
    }
    
    func convertDate() -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        guard let date = df.date(from: self) else { return nil }
        
        df.dateFormat = "HH:mm dd/MM/yyyy"
        return df.string(from: date)
    }
}
