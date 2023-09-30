//
//  Placemark.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 25.09.2023.
//

import UIKit

struct Placemark: Codable {
    
    enum Tag: String, Codable {
        case forMalesOnly = "for_males_only"
        case forPeopleWithReducedMobility = "for_invalides"
        case forFemalesOnly = "for_females_only"
        case forAdultsOnly = "for_adults_only"
    }
    
    let creatorID: String?
    let creator: Creator?
    let userCount: Int?
    let id: String?
    let permissions, photosURL: [String]?
    let latitude: Double
    let duration: Int?
    let price: Int?
    let desc: String?
    let tags: [Tag]?
    let updatedAt: String?
    let pinURL: String?
    let createdAt: String?
    let toDate: Int?
    let longitude: Double
    let collectionID, event: String?
}

extension Placemark {
    enum CodingKeys: String, CodingKey {
        case creatorID, creator, userCount, id, permissions
        case photosURL = "photosUrl"
        case latitude, duration
        case price, desc, tags, updatedAt
        case pinURL = "pinUrl"
        case createdAt, toDate, longitude
        case collectionID = "collectionId"
        case event
    }
}

