//
//  UserAccount.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 04.09.2023.
//

import Appwrite

fileprivate enum LoginError: Error {
    case unableToLogin(String)
    case unableToDeleteSession(String)
}

final class UserAccount: AWClient {
    
    static let shared = UserAccount()
    
    private lazy var account: Account = {
        Account(client)
    }()
    
    private lazy var functions: Functions = {
        Functions(client)
    }()
    
    @UserDataStorage<String>(key: UserDefaultsKey.loginSessionID)
    private var sessionID: String?
    
    private override init() {
        super.init()
    }
    
    func confirmCode(_ code: String) async throws -> ConfirmCodeResponseModel? {
        let body = await ConfirmCodeModel(jwt: try account.createJWT().jwt, code: code)
        let response = try await functions.createExecution(functionId: "654572cb117c272cb82f", body: body.toJson())
        return try response.responseBody.fromJson(to: ConfirmCodeResponseModel.self)
    }
    
    func inputPhone() async throws {
        let body = await InputPhoneModel(jwt: try account.createJWT().jwt)
        let _ = try await functions.createExecution(functionId: "6544f38254bc65fa3145", body: body.toJson())
    }
    
    func createAccount(email: String, userID: String, name: String? = nil) async throws {
        let _ = try await account.create(
            userId: userID,
            email: email,
            password: userID,
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
