//
//  LoginViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelProtocol
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModel()
    }
    
    private func addTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        loginView.emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldChanged),
            for: .editingChanged
        )
        
        loginView.emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldDoneEditing),
            for: .editingDidEndOnExit
        )
        
        loginView.passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldChanged),
            for: .editingChanged
        )
        
        loginView.passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldDoneEditing),
            for: .editingDidEndOnExit
        )
        
        loginView.showPasswordButton.addTarget(
            self,
            action: #selector(showHidePasswordButtonTapped),
            for: .touchUpInside
        )
        
        loginView.loginButton.addTarget(
            self,
            action: #selector(loginButtonPressed),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        viewModel.outputs.isFormValid
            .subscribe(onNext: { [weak self] isFormValid in
                self?.loginView.loginButton.isEnabled = isFormValid
                self?.loginView.loginButton.alpha = isFormValid ? 1 : 0.5
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordTextFieldBecomeFirstResponder
            .subscribe(onNext: { [weak self] _ in
                self?.loginView.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showHidePasswordButtonToggled
            .subscribe(onNext: { [weak self] shouldShowPassword in
                self?.loginView.passwordTextField.isSecureTextEntry = !shouldShowPassword
                self?.loginView.showPasswordButton.tintColor = shouldShowPassword ? Colors.letsgo_main_red : Colors.letsgo_dark_gray
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.showError
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] message in
                self?.present(UIAlertController.error(message), animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.displayLoader
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] in
                self?.displayLoader()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.removeLoader
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)
    }
    
}

extension LoginViewController {
    @objc private func emailTextFieldChanged(_ textField: UITextField) {
        viewModel.inputs.emailChanged(textField.text)
    }
    
    @objc private func emailTextFieldDoneEditing() {
        viewModel.inputs.emailTextFieldDoneEditing()
    }
    
    @objc private func passwordTextFieldChanged(_ textField: UITextField) {
        viewModel.inputs.passwordChanged(textField.text)
    }
    
    @objc private func passwordTextFieldDoneEditing() {
        viewModel.inputs.passwordTextFieldDoneEditing()
    }
    
    @objc private func loginButtonPressed() {
        viewModel.inputs.loginButtonPressed()
    }
    
    @objc private func showHidePasswordButtonTapped() {
        viewModel.inputs.showHidePasswordButtonTapped()
    }
    
    @objc private func dismissKeyboard() {
        loginView.endEditing(true)
    }
}

extension LoginViewController: DisplayLoaderInterface {}
