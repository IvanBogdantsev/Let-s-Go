//
//  ButtonStyles.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 31.08.2023.
//

import UIKit

extension UIButton {
    func defaultStyle() {
        setTitleColor(.letsgo_white, for: .normal)
        titleLabel?.font = .letsgo_title3()
        layer.cornerRadius = 10
    }
    
    func defaultStyleRed() {
        defaultStyle()
        backgroundColor = .letsgo_main_red
    }
    
    func defaultStyleGray() {
        defaultStyle()
        backgroundColor = .letsgo_dark_gray        
    }
    
    func defaultStyleBoldedRed() {
        defaultStyleRed()
        titleLabel?.font = titleLabel?.font.bolded
    }
    
    func loginStyle() {
        defaultStyleBoldedRed()
        setTitle(Strings.login.capitalized, for: .normal)
    }
    
    func framelessStyle() {
        titleLabel?.font = .letsgo_body()
        setTitleColor(.letsgo_white, for: .normal)
    }
    
    func sighUpStyle() {
        defaultStyleBoldedRed()
        setTitle(Strings.create_an_account, for: .normal)
    }
}
