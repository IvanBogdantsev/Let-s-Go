//
//  EnterCodeViewController.swift
//  Let's Go
//
//  Created by Timur Israilov on 11/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EnterCodeViewController: UIViewController {
    // MARK: - Private properties
    private let enterCodeView = EnterCodeView()
    private let disposeBag = DisposeBag()
    private let viewModel: EnterCodeViewModel
    // MARK: - Init
    init(viewModel: EnterCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Override methods
    override func loadView() {
        view = enterCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackButton()
        setupNavigationTitleView()
        bindActions()
    }
    // MARK: - UI Methods
    private func setupNavigationTitleView() {
        let label = UILabel()
        label.text = "Подтвердите вход"
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = UIColor(resource: .mainBlack)
        navigationItem.titleView = label
    }
    
    private func setCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(resource: .chevronBack), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    // MARK: - Private Methods
    private func bindActions() {
        enterCodeView.sendCodeAgaingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.enterCodeView.startTimer()
                self?.viewModel.inputs.sendCodeAgain()
            })
            .disposed(by: disposeBag)
        
        enterCodeView.codeTextField.rx.controlEvent([.valueChanged])
            .asObservable().subscribe({ [weak self] _ in
                guard let self else { return }
                self.viewModel.inputs.enteredCode(self.enterCodeView.codeTextField.code)
            }).disposed(by: disposeBag)
        
        viewModel.outputs.isCodeSuccessed.subscribe { [weak self] isCodeSuccessed in
            DispatchQueue.main.async {
                self?.enterCodeView.setIsValid(isCodeSuccessed)
            }
        }.disposed(by: disposeBag)
        
        enterCodeView.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.inputs.login()
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
