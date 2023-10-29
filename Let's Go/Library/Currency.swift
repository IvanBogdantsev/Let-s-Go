//
//  Currency.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.10.2023.
//

enum Currency {
    case RUB
    
    var userFacing: String {
        switch self {
        case .RUB:
            return Strings.RUB
        }
    }
}
