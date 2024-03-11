//
//  LoginViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    // MARK: - Private properties
    private let viewModel: LoginViewModelProtocol
    private let loginView = LoginView()
    private let disposeBag = DisposeBag()
    private var formInitialFrame: CGRect?
    
    // MARK: - Init
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Private methods
    private func bind() {
        viewModel.outputs.isFormValid.subscribe { [weak self] isValid in
            self?.loginView.setIsValid(true)
        }
        .disposed(by: disposeBag)
        
        loginView.phoneTextFieldChanged.subscribe { [weak self] phone in
            self?.viewModel.inputs.phoneChanged(phone)
        }
        .disposed(by: disposeBag)
        
        loginView.checkboxChanged.subscribe { [weak self] isChecked in
            self?.viewModel.inputs.checkboxChanged(isChecked)
        }
        .disposed(by: disposeBag)
        
        loginView.nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.countinueButtonPressed()
            })
            .disposed(by: disposeBag)
    }
}
