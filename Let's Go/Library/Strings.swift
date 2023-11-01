//
//  Strings.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 21.08.2023.
//

enum Strings {
    static let email = "email".localized()
    static let password = "password".localized()
    static let login_into_account = "login_into_account".localized()
    static let login = "login".localized()
    static let forgot_password = "forgot_password".localized()
    static let create_an_account = "create_an_account".localized()
    static let name = "name".localized()
    static let not_less_than_eight_characters = "not_less_than_eight_characters".localized()
    static let ok = "ok".localized()
    static let something_wrong = "something_wrong".localized()
    static let map = "map".localized()
    static let favorites = "favorites".localized()
    static let chat = "chat".localized()
    static let profile = "profile".localized()
    static let optional = "optional".localized()
    static let continue_as_guest = "continue_as_guest".localized()
    static let event_without_name = "event_without_name".localized()
    static let unknown = "unknown".localized()
    static let RUB = "₽"
    static let participation_cost = "participation_cost".localized()
    static let date = "date".localized()
    static let will_last = "will_last".localized()
    static let details = "details".localized()
    static let creator = "creator".localized()
    static let active = "active".localized()
    static let go = "go".localized()
    
    static func participants_of_total(num: Int, of total: Int) -> String {
        let format = "%d_from_%d participants".localized()
        return String(format: format, num, total)
    }
    
    static func num_participants(num: Int) -> String {
        let format = "participants:_%d".localized()
        return String(format: format, num)
    }
}
