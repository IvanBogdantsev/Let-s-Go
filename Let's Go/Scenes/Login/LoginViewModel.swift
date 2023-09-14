//
//  LoginViewModel.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit
import RxSwift
import RxRelay
import Appwrite

protocol LoginViewModelInputs {
    func emailChanged(_ email: String?)
    func emailTextFieldDoneEditing()
    func loginButtonPressed()
    func passwordChanged(_ password: String?)
    func passwordTextFieldDoneEditing()
    func showHidePasswordButtonTapped()
}

protocol LoginViewModelOutputs {
    var dismissKeyboard: Observable<Void>! { get }
    var isFormValid: Observable<Bool>! { get }
    var passwordTextFieldBecomeFirstResponder: Observable<Void>! { get }
    var showError: Observable<String>! { get }
    var showHidePasswordButtonToggled: Observable<Bool>! { get }
    var displayLoader: Observable<Void>! { get }
    var removeLoader: Observable<Void>! { get }
}

protocol LoginViewModelProtocol {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelProtocol, LoginViewModelOutputs {
    
    var inputs: LoginViewModelInputs { self }
    var outputs: LoginViewModelOutputs { self }
    
    var dismissKeyboard: Observable<Void>!
    var isFormValid: Observable<Bool>!
    var passwordTextFieldBecomeFirstResponder: Observable<Void>!
    var showError: Observable<String>!
    var showHidePasswordButtonToggled: Observable<Bool>!
    var displayLoader: Observable<Void>!
    var removeLoader: Observable<Void>!
    
    private let emailChangedValue = PublishRelay<String?>()
    private let emailTextFieldDoneEditingValue = PublishRelay<Void>()
    private let loginButtonPressedValue = PublishRelay<Void>()
    private let passwordChangedValue = PublishRelay<String?>()
    private let passwordTextFieldDoneEditingValue = PublishRelay<Void>()
    private let showHidePasswordButtonTappedValue = PublishRelay<Void>()
    
    private let sceneOutput: LoginSceneOutput?
    
    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
        
        self.passwordTextFieldBecomeFirstResponder = emailTextFieldDoneEditingValue.asObservable()
        
        let emailAndPassword = Observable.combineLatest(
            emailChangedValue.skipNil(),
            passwordChangedValue.skipNil()
        )
            .share()
        
        self.isFormValid = emailAndPassword.map(isValid)
            .startWith(false)
        
        self.showHidePasswordButtonToggled = showHidePasswordButtonTappedValue
            .scan(false) { currentValue, _ in
                return !currentValue
            }
            .startWith(false)
        
        let tryLogin = Observable.merge(
            loginButtonPressedValue.asObservable(),
            passwordTextFieldDoneEditingValue.asObservable()
        )
        
        let loginEvent = tryLogin
            .withLatestFrom(emailAndPassword)
            .map { email, password in
                Task {
                    try await UserAccount.shared.createEmailSession(email: email, password: password)
                    sceneOutput?.login()
                }
            }
            .asObservable()
            .share()
        
        let result = loginEvent.values
            .map { await $0.result }
            .asObservable()
            .share()
        
        self.displayLoader = loginEvent.ignoreValues()
        self.removeLoader = result.asObservable().ignoreValues()
        
        self.showError = result
            .compactMap { result in
                switch result {
                case .failure(let error):
                    return error.localizedDescription
                default:
                    return nil
                }
            }
    }
    
    private func isValid(email: String, password: String) -> Bool {
        return isValidEmail(email) && !password.isEmpty
    }
    
}

extension LoginViewModel: LoginViewModelInputs {
    func emailChanged(_ email: String?) {
        emailChangedValue.accept(email)
    }
    
    func emailTextFieldDoneEditing() {
        emailTextFieldDoneEditingValue.accept(Void())
    }
    
    func loginButtonPressed() {
        loginButtonPressedValue.accept(Void())
    }
    
    func passwordChanged(_ password: String?) {
        passwordChangedValue.accept(password)
    }
    
    func passwordTextFieldDoneEditing() {
        passwordTextFieldDoneEditingValue.accept(Void())
    }
    
    func showHidePasswordButtonTapped() {
        showHidePasswordButtonTappedValue.accept(Void())
    }
}
