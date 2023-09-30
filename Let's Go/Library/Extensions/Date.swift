//
//  Date.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 30.09.2023.
//

import Foundation

extension Date {
    var timeIntervalSince1970mls: Int {
        Int(self.timeIntervalSince1970 * 1000)
    }
}
