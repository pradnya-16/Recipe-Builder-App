//
//  PopUp.swift
//  Final Project
//
//  Created by Pradnya Kadam on 3/16/25.
//

import UIKit

extension UIViewController {
    func showPopupMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

