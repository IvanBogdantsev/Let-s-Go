//
//  isValidEmail.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 01.09.2023.
//

import Foundation

private let emailRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{1,7})*$"
private let phoneRegex = "^[0-9+]{0,1}+[0-9]{10,16}$"


func isValidEmail(_ email: String) -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return predicate.evaluate(with: email) 
}

func isValidPhone(phone: String) -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return predicate.evaluate(with: phone)
}
