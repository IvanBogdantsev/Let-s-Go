//
//  UETextField.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 17.05.2023.
//

import UIKit

extension UITextField {
    func setAttributedPlaceholder(_ string: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor : color])
    }
}
