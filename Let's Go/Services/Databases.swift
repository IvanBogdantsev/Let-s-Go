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
            AWConstants.marksСollectionId
        case .registrations:
            AWConstants.registrationsCollectionId
        case .users:
            AWConstants.usersCollectionId
        }
    }
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
        return try await databases.listDocuments(databaseId: AWConstants.databaseId, collectionId: collection.id, queries: queries, nestedType: T.self).documents.map { $0.data }
    }
    
    func getItem<T: Codable>(_ type: T.Type, from collection: Collection, itemId: String, queries: [String]? = nil) async throws -> T {
        return try await databases.getDocument(databaseId: AWConstants.databaseId, collectionId: collection.id, documentId: itemId, queries: queries, nestedType: T.self).data
    }
    
}
