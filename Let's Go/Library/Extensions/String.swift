//
//  String.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 21.08.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
