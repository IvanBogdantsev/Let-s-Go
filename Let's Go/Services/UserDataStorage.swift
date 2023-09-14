//
//  UserDataStorage.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 07.09.2023.
//

import Foundation

enum UserDefaultsKey {
    static let loginSessionID = "com.let-s-go.loginSessionID"
}

@propertyWrapper
struct UserDataStorage<T: Codable> {
    private let key: String
    
    private let userDefaults = UserDefaults.standard
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            return (userDefaults.object(forKey: key) as? Data).flatMap {
                try? JSONDecoder().decode(T.self, from: $0)
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: key)
            }
        }
    }
}
