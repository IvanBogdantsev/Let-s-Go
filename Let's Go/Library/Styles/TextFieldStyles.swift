//
//  TextFieldStyles.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 31.08.2023.
//

import UIKit

extension UITextField {
    func defaultStyle() {
        tintColor = Colors.letsgo_main_red
        textColor = Colors.letsgo_white
        font = UIFont.letsgo_body()
    }
    
    func emailStyle() {
        defaultStyle()
        leftView = UIImageView(image: Images.enveloppe_fill)
        leftViewMode = .always
        setAttributedPlaceholder(Strings.email.capitalized, color: Colors.letsgo_dark_gray)
        keyboardType = .emailAddress
        autocorrectionType = .no
        autocapitalizationType = .none
        textContentType = .emailAddress
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 10
    }
    
    func securedEntryStyle() {
        defaultStyle()
        leftView = UIImageView(image: Images.key_fill)
        leftViewMode = .always
        setAttributedPlaceholder(Strings.password.capitalized, color: Colors.letsgo_dark_gray)
        rightViewMode = .always
        textContentType = .password
        isSecureTextEntry = true
    }
    
    func nameStyle() {
        defaultStyle()
        leftView = UIImageView(image: Images.person_fill)
        leftViewMode = .always
        setAttributedPlaceholder(Strings.name.capitalized, color: Colors.letsgo_dark_gray)
        textContentType = .name
        autocorrectionType = .no
        autocapitalizationType = .words
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 10
    }
}
