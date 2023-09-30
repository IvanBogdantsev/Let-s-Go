//
//  Creator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 25.09.2023.
//

struct Creator: Codable {
    let name, description, smallDescription, city: String
    let photoURL: String

    enum CodingKeys: String, CodingKey {
        case name, description, smallDescription, city
        case photoURL = "photoUrl"
    }
}
