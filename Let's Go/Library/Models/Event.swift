//
//  Event.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 25.09.2023.
//

import UIKit

struct Event: Codable {
    
    enum Tag: String, Codable {
        case forMalesOnly = "for_males_only"
        case forPeopleWithReducedMobility = "for_invalides"
        case forFemalesOnly = "for_females_only"
        case forAdultsOnly = "for_adults_only"
    }
    
    let creatorID: String?
    let creator: Creator?
    let userCount: Int?
    let id: String
    let permissions: [String]?
    let photosURL: [URL]
    let latitude: Double
    let duration: Int?
    let cost: Int?
    let desc: String?
    let tags: [Tag]
    let updatedAt: String?
    let pinURL: URL?
    let createdAt: String?
    let toDate: Int?
    let longitude: Double
    let collectionID, event: String?
}

extension Event {
    enum CodingKeys: String, CodingKey {
        case creatorID, creator, userCount, permissions
        case id = "$id"
        case photosURL = "photosUrl"
        case latitude, duration
        case desc, tags, updatedAt
        case cost = "price"
        case pinURL = "pinUrl"
        case createdAt, toDate, longitude
        case collectionID = "collectionId"
        case event
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        creatorID = try container.decodeIfPresent(String.self, forKey: .creatorID)
        creator = try container.decodeIfPresent(Creator.self, forKey: .creator)
        userCount = try container.decodeIfPresent(Int.self, forKey: .userCount)
        id = try container.decode(String.self, forKey: .id)
        permissions = try container.decodeIfPresent([String].self, forKey: .permissions)
        latitude = try container.decode(Double.self, forKey: .latitude)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        cost = try container.decodeIfPresent(Int.self, forKey: .cost)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        toDate = try container.decodeIfPresent(Int.self, forKey: .toDate)
        longitude = try container.decode(Double.self, forKey: .longitude)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        event = try container.decodeIfPresent(String.self, forKey: .event)
        tags = try container.decodeIfPresent([Tag].self, forKey: .tags) ?? []
        photosURL = (try? container.decodeIfPresent([URL].self, forKey: .photosURL)) ?? []
        pinURL = try? container.decodeIfPresent(URL.self, forKey: .pinURL)
    }
}

