//
//  SignUpViewModel.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 02.09.2023.
//

import UIKit
import RxSwift
import RxRelay

protocol SignUpViewModelInputs {
    func nameChanged(_ email: String?)
    func nameTextFieldDoneEditing()
    func emailChanged(_ email: String?)
    func emailTextFieldDoneEditing()
    func passwordChanged(_ password: String?)
    func passwordTextFieldDoneEditing()
    func showHidePasswordButtonTapped()
    func signUpButtonPressed()
}

protocol SignUpViewModelOutputs {
    var dismissKeyboard: Observable<Void>! { get }
    var nameTextFieldBecomeFirstResponder: Observable<Void>! { get }
    var emailTextFieldBecomeFirstResponder: Observable<Void>! { get }
    var passwordTextFieldBecomeFirstResponder: Observable<Void>! { get }
    var showError: Observable<String>! { get }
    var showHidePasswordButtonToggled: Observable<Bool>! { get }
    var isFormValid: Observable<Bool>! { get }
    var displayLoader: Observable<Void>! { get }
    var removeLoader: Observable<Void>! { get }
}

protocol SignUpViewModelProtocol {
    var inputs: SignUpViewModelInputs { get }
    var outputs: SignUpViewModelOutputs { get }
}

final class SignUpViewModel: SignUpViewModelProtocol, SignUpViewModelOutputs {
    
    var inputs: SignUpViewModelInputs { self }
    var outputs: SignUpViewModelOutputs { self }

    var dismissKeyboard: Observable<Void>!
    var nameTextFieldBecomeFirstResponder: Observable<Void>!
    var emailTextFieldBecomeFirstResponder: Observable<Void>!
    var passwordTextFieldBecomeFirstResponder: Observable<Void>!
    var showError: Observable<String>!
    var showHidePasswordButtonToggled: Observable<Bool>!
    var isFormValid: Observable<Bool>!
    var displayLoader: Observable<Void>!
    var removeLoader: Observable<Void>!
    
    private let nameChangedValue = PublishRelay<String?>()
    private let nameTextFieldDoneEditingValue = PublishRelay<Void>()
    private let emailChangedValue = PublishRelay<String?>()
    private let emailTextFieldDoneEditingValue = PublishRelay<Void>()
    private let passwordChangedValue = PublishRelay<String?>()
    private let passwordTextFieldDoneEditingValue = PublishRelay<Void>()
    private let showHidePasswordButtonTappedValue = PublishRelay<Void>()
    private let signUpButtonPressedValue = PublishRelay<Void>()
    
    private let sceneOutput: LoginSceneOutput?
    
    init(sceneOutput: LoginSceneOutput?) {
        self.sceneOutput = sceneOutput
        
        self.emailTextFieldBecomeFirstResponder = nameTextFieldDoneEditingValue.asObservable()
        self.passwordTextFieldBecomeFirstResponder = emailTextFieldDoneEditingValue.asObservable()
        
        let emailPasswordAndName = Observable.combineLatest(
            emailChangedValue.skipNil(),
            passwordChangedValue.skipNil(),
            nameChangedValue.startWith(nil)
        )
        
        self.isFormValid = emailPasswordAndName.map { [weak self] email, password, _ in
            guard let self else { return true }
            return self.isValid(email: email, password: password)
        }
            .startWith(false)
        
        self.showHidePasswordButtonToggled = showHidePasswordButtonTappedValue
            .scan(false) { currentValue, _ in
                return !currentValue
            }
            .startWith(false)
        
        let tryLogin = Observable.merge(
            signUpButtonPressedValue.asObservable(),
            passwordTextFieldDoneEditingValue.asObservable()
        )
        
        let loginEvent = tryLogin
            .withLatestFrom(emailPasswordAndName)
            .map { email, password, name in
                Task {
                    try await UserAccount.shared.createAccount(email: email, password: password, name: name)
                    sceneOutput?.login()
                    try await UserAccount.shared.createEmailSession(email: email, password: password)
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
        return isValidEmail(email) && password.count >= 8
    }
    
}

extension SignUpViewModel: SignUpViewModelInputs {
    func nameChanged(_ email: String?) {
        nameChangedValue.accept(email)
    }
    
    func nameTextFieldDoneEditing() {
        nameTextFieldDoneEditingValue.accept(Void())
    }
    
    func emailChanged(_ email: String?) {
        emailChangedValue.accept(email)
    }
    
    func emailTextFieldDoneEditing() {
        emailTextFieldDoneEditingValue.accept(Void())
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
    
    func signUpButtonPressed() {
        signUpButtonPressedValue.accept(Void())
    }
}
