//
//  EnterCodeViewModel.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import Foundation
import RxRelay
import RxSwift

protocol EnterCodeViewModelInputs {
    func enteredCode(_ code: String)
    func login()
    func sendCodeAgain()
}

protocol EnterCodeViewModelOutputs {
    var isCodeSuccessed: Observable<Bool> { get }
    
}

protocol EnterCodeViewModelProtocol {
    var inputs: EnterCodeViewModelInputs { get }
    var outputs: EnterCodeViewModelOutputs { get }
}

final class EnterCodeViewModel: EnterCodeViewModelProtocol, EnterCodeViewModelOutputs {
    // MARK: - Public Properties
    var inputs: EnterCodeViewModelInputs { self }
    var outputs: EnterCodeViewModelOutputs { self }
    var isCodeSuccessed: Observable<Bool> = Observable.just(false)
    // MARK: - Private Properties
    private let sceneOutput: LoginSceneOutput?
    private var code: String = ""
    private var response: ConfirmCodeResponseModel?
    private let disposedBag = DisposeBag()
    // MARK: - Init
    init(sceneOutput: LoginSceneOutput?) { 
        self.sceneOutput = sceneOutput
    }
}
// MARK: - EnterCodeViewModelInputs
extension EnterCodeViewModel: EnterCodeViewModelInputs {
    func sendCodeAgain() {
        Task {
            try await UserAccount.shared.inputPhone()
        }
    }
    
    func login() {
        if code.count < 4 {
            return
        }
        Task {
            if let response {
                try await UserAccount.shared.deleteSession()
                try await UserAccount.shared.createEmailSession(email: response.mail, password: response.password)
                sceneOutput?.login()
            }
        }
    }
    
    func enteredCode(_ code: String) {
        if code.count < 4 {
            return
        }
        Task {
            do {
                let response = try await UserAccount.shared.confirmCode(code)
                self.response = response
                self.code = code
                isCodeSuccessed = Observable.just(response != nil)
            } catch {
                print(error)
            }
        }
    }
}
