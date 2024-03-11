//
//  InputPhoneModel.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import Foundation

struct InputPhoneModel: Codable {
    var jwt: String
    
    func makeJsonString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Ошибка \(error.localizedDescription)")
        }
        return nil
    }
}
