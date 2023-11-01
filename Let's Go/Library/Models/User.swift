//
//  Creator.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 25.09.2023.
//

import Foundation

struct User {
    let id: String
    let name, description, smallDescription, city: String?
    let photoURL: URL?
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "$id"
        case name, description, smallDescription, city
        case photoURL = "photoUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        smallDescription = try container.decodeIfPresent(String.self, forKey: .smallDescription)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        photoURL = try? container.decodeIfPresent(URL.self, forKey: .photoURL)
    }
}
