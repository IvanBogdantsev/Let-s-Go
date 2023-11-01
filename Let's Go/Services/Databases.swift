//
//  Databases.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

import Appwrite

enum Collection {
    case marks
    case registrations
    case users
    
    fileprivate var id: String {
        switch self {
        case .marks:
            Constants.marksСollectionId
        case .registrations:
            Constants.registrationsCollectionId
        case .users:
            Constants.usersCollectionId
        }
    }
}

fileprivate enum Constants {
    static let databaseId = "63e2b4503fa1bf5d1a5f"
    static let marksСollectionId = "63e2b456b185a4c53116"
    static let registrationsCollectionId = "646f33df2ebfbdbb56a2"
    static let usersCollectionId = "646d0d2149f236a62413"
}

final class Databases: AWClient {
    
    static let shared = Databases()
    
    private lazy var databases: Appwrite.Databases = {
        Appwrite.Databases(client)
    }()
    
    private override init() {
        super.init()
    }
    
    func getItems<T: Codable>(_ type: T.Type, from collection: Collection, queries: [String]? = nil) async throws -> [T] {
        return try await databases.listDocuments(databaseId: Constants.databaseId, collectionId: collection.id, queries: queries, nestedType: T.self).documents.map { $0.data }
    }
    
    func getItem<T: Codable>(_ type: T.Type, from collection: Collection, itemId: String, queries: [String]? = nil) async throws -> T {
        return try await databases.getDocument(databaseId: Constants.databaseId, collectionId: collection.id, documentId: itemId, queries: queries, nestedType: T.self).data
    }
    
}
