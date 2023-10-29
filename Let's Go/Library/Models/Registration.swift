//
//  Registration.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 24.10.2023.
//

struct Registration: Codable {
    let status, userID, markID: String
    let dateOfEvent: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case userID
        case markID
        case dateOfEvent
    }
}
