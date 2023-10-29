//
//  Databases.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

import Appwrite

enum DatabaseItem {
    case marks
    case registrations
    
    fileprivate var id: String {
        switch self {
        case .marks:
            Constants.marksСollectionId
        case .registrations:
            Constants.registrationsCollectionId
        }
    }
}

fileprivate enum Constants {
    static let databaseId = "63e2b4503fa1bf5d1a5f"
    static let marksСollectionId = "63e2b456b185a4c53116"
    static let registrationsCollectionId = "646f33df2ebfbdbb56a2"
}

final class Databases: AWClient {
    
    static let shared = Databases()
    
    private lazy var databases: Appwrite.Databases = {
        Appwrite.Databases(client)
    }()
    
    private override init() {
        super.init()
    }
    
    func getItems<T: Codable>(_ type: T.Type, items: DatabaseItem, queries: [String]? = nil) async throws -> [T] {
        return try await databases.listDocuments(databaseId: Constants.databaseId, collectionId: items.id, queries: queries, nestedType: T.self).documents.map { $0.data }
    }
     
    
}
