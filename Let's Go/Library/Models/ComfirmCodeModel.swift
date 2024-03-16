//
//  ComfirmCodeModel.swift
//  Let's Go
//
//  Created by Timur Israilov on 16/03/24.
//

import Foundation

struct ConfirmCodeModel: Codable {
    var jwt: String
    var code: String
}

struct ConfirmCodeResponseModel: Codable {
    var mail: String
    var password: String
}
