//
//  SignUpViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 02.09.2023.
//

import UIKit
import RxSwift

final class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    private let viewModel: SignUpViewModelProtocol 
    private let disposeBag = DisposeBag()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.letsgo_main_gray
        addTargets()
        bindViewModel()
    }
    
    private func addTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        signUpView.nameTextField.addTarget(
            self,
            action: #selector(nameTextFieldChanged),
            for: .editingChanged
        )
        
        signUpView.nameTextField.addTarget(
            self,
            action: #selector(nameTextFieldDoneEditing),
            for: .editingDidEndOnExit
        )
        
        signUpView.emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldChanged),
            for: .editingChanged
        )
        
        signUpView.emailTextField.addTarget(
            self,
            action: #selector(emailTextFieldDoneEditing),
            for: .editingDidEndOnExit
        )
        
        signUpView.passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldChanged),
            for: .editingChanged
        )
        
        signUpView.passwordTextField.addTarget(
            self,
            action: #selector(passwordTextFieldDoneEditing),
            for: .editingDidEndOnExit
        )
        
        signUpView.showPasswordButton.addTarget(
            self,
            action: #selector(showHidePasswordButtonTapped),
            for: .touchUpInside
        )
        
        signUpView.signUpButton.addTarget(
            self,
            action: #selector(signUpButtonPressed),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        viewModel.outputs.emailTextFieldBecomeFirstResponder
            .subscribe(onNext: { [weak self] _ in
                self?.signUpView.emailTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordTextFieldBecomeFirstResponder
            .subscribe(onNext: { [weak self] _ in
                self?.signUpView.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.isFormValid
            .subscribe(onNext: { [weak self] isFormValid in
                self?.signUpView.signUpButton.isEnabled = isFormValid
                self?.signUpView.signUpButton.alpha = isFormValid ? 1 : 0.5
            })
            .disposed(by: disposeBag)

        viewModel.outputs.showHidePasswordButtonToggled
            .subscribe(onNext: { [weak self] shouldShowPassword in
                self?.signUpView.passwordTextField.isSecureTextEntry = !shouldShowPassword
                self?.signUpView.showPasswordButton.tintColor = shouldShowPassword ? Colors.letsgo_main_red : Colors.letsgo_dark_gray
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
        
        viewModel.outputs.showError
            .observeOnMainThread()
            .subscribe(onNext: { [weak self] message in
                self?.present(UIAlertController.error(message), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension SignUpViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func nameTextFieldChanged(_ textField: UITextField) {
        viewModel.inputs.nameChanged(textField.text)
    }
    
    @objc private func nameTextFieldDoneEditing() {
        viewModel.inputs.nameTextFieldDoneEditing()
    }
    
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
    
    @objc private func signUpButtonPressed() {
        viewModel.inputs.signUpButtonPressed()
    }
    
    @objc private func showHidePasswordButtonTapped() {
        viewModel.inputs.showHidePasswordButtonTapped()
    }
}

extension SignUpViewController: DisplayLoaderInterface {}
