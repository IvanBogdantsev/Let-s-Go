//
//  UserAccount.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 04.09.2023.
//

import Appwrite

fileprivate enum Constants {
    static let endpoint = "http://89.253.229.81/v1"
    static let projectID = "63e2b309e37828599409"
}

fileprivate enum LoginError: Error {
    case unableToLogin(String)
    case unableToDeleteSession(String)
}

final class UserAccount {
    
    static let shared = UserAccount()
    
    private let client: Client
    private let account: Account
    
    @UserDataStorage<String>(key: UserDefaultsKey.loginSessionID)
    private var sessionID: String?
    
    private init() {
        client = Client()
            .setEndpoint(Constants.endpoint)
            .setProject(Constants.projectID)
        account = Account(client)
    }
    
    func createAccount(email: String, password: String, name: String? = nil) async throws {
        let _ = try await account.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: name
        )
    }
    
    func createEmailSession(email: String, password: String) async throws {
        let session = try await account.createEmailSession(email: email, password: password)
        sessionID = session.id
    }
    
    func createAnonymousSession() async throws {
        let session = try await account.createAnonymousSession()
        sessionID = session.id
    }
    
    func login() async throws {
        guard let sessionID else { throw LoginError.unableToLogin("could not retrieve session ID") }
        let _ = try await account.getSession(sessionId: sessionID)
    }
    
    func deleteSession() async throws {
        guard let sessionID else { throw LoginError.unableToDeleteSession("could not retrieve session ID") }
        self.sessionID = nil
        let _ = try await account.deleteSession(sessionId: sessionID)
    }
    
}
