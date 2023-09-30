//
//  AWClient.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

import Appwrite

fileprivate enum Constants {
    static let endpoint = "http://89.253.229.81/v1"
    static let projectID = "63e2b309e37828599409"
}

class AWClient {
    
    let client: Client
    
    init() {
        client = Client()
            .setEndpoint(Constants.endpoint)
            .setProject(Constants.projectID)
    }
    
}
