//
//  LoginViewModel.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import RxSwift
import RxRelay
import Appwrite
import Foundation

protocol LoginViewModelInputs {
    func phoneChanged(_ phone: String?)
    func checkboxChanged(_ isChecked: Bool)
    func countinueButtonPressed()
}

protocol LoginViewModelOutputs {
    var isFormValid: Observable<Bool>! { get }
}

protocol LoginViewModelProtocol {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelProtocol, LoginViewModelOutputs {
    // MARK: - Public Properties
    var inputs: LoginViewModelInputs { self }
    var outputs: LoginViewModelOutputs { self }
    var isFormValid: Observable<Bool>!
    // MARK: - Private Properties
    private let phoneChangedValue = PublishRelay<String?>()
    private let checkboxChangedValue = PublishRelay<Bool?>()
    private let sceneOutput: LoginSceneOutput?
    private var phone: String = ""
    // MARK: - Init
    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
        let phoneAndCheckbox = Observable.combineLatest(phoneChangedValue.skipNil(), checkboxChangedValue.asObservable().skipNil()).share()
        self.isFormValid = phoneAndCheckbox.map { [weak self] phone, isChecked in
            guard let self else { return  false }
            let isValidPhone = self.isValid(phone: phone)
            if isValidPhone {
                self.phone = phone
            }
            return isValidPhone && isChecked
        }
    }
    // MARK: - Private methods
    private func isValid(phone: String) -> Bool {
        return isValidPhone(phone: phone)
    }
}
// MARK: - LoginViewModelInputs
extension LoginViewModel: LoginViewModelInputs {
    func countinueButtonPressed() {
        let id = UUID().uuidString
        let userId = "\(phone)@\(id).ru"
        Task {
            do {
                try await UserAccount.shared.createAccount(email: userId, userID: id)
                try await UserAccount.shared.createEmailSession(email: userId, password: id)
                try await UserAccount.shared.inputPhone()
            } catch {
                print(error)
            }
        }
        sceneOutput?.goToEnterCode()
    }
    
    func checkboxChanged(_ isChecked: Bool) {
        checkboxChangedValue.accept(isChecked)
    }
    
    func phoneChanged(_ phone: String?) {
        phoneChangedValue.accept(phone)
    }
}
