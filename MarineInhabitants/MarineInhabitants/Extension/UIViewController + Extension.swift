//
//  UIViewController + Extension.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 4/5/22.
//

import UIKit

extension UIViewController {
    func presentAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func calculatePercentage(value: Double, percentageVal: Double) -> Double {
        let val = value * percentageVal
        return val / 100.0
    }
}
