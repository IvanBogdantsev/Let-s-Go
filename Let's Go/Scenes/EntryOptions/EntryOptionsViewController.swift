//
//  EntryOptionsViewController.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 13.09.2023.
//

import UIKit

final class EntryOptionsViewController: UIViewController {
    
    private var sceneOutput: LoginSceneOutput?
    
    private let vStackView = UIStackView(axis: .vertical, spacing: 25)
    private let signUpButton = UIButton()
    private let loginButton = UIButton()
    private let continueAsGuestButton = UIButton()
    private let logo = UIImageView(image: Images.logo_white)
    
    init(sceneOutput: LoginSceneOutput?) {
        super.init(nibName: nil, bundle: nil)
        self.sceneOutput = sceneOutput
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setStyle()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        continueAsGuestButton.addTarget(self, action: #selector(continueAsGuestButtonPressed), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(vStackView)
        vStackView.addArrangedSubviews(logo, signUpButton, loginButton, continueAsGuestButton)
        
        logo.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        vStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(40)
        }
        
        vStackView.setCustomSpacing(50, after: logo)
    }
    
    private func setStyle() {
        view.backgroundColor = Colors.letsgo_main_gray
        
        logo.contentMode = .scaleAspectFit
        
        signUpButton.defaultStyleRed()
        loginButton.defaultStyleGray()
        signUpButton.setTitle(Strings.create_an_account, for: .normal)
        loginButton.setTitle(Strings.login_into_account, for: .normal)
        
        continueAsGuestButton.framelessStyle()
        continueAsGuestButton.setTitle(Strings.continue_as_guest, for: .normal)
        continueAsGuestButton.setTitleColor(Colors.letsgo_main_red, for: .normal)
    }
    
    @objc private func signUpButtonPressed() {
        sceneOutput?.goToSignUp()
    }
    
    @objc private func loginButtonPressed() {
        sceneOutput?.goToLogin()
    }
    
    @objc private func continueAsGuestButtonPressed() {
        displayLoader()
        Task {
            defer {
                DispatchQueue.main.async {
                    self.hideLoader()
                }
            }
            do {
                try await UserAccount.shared.createAnonymousSession()
                sceneOutput?.login()
            } catch {
                DispatchQueue.main.async {
                    self.present(UIAlertController.error(error.localizedDescription), animated: true)
                }
            }
        }
    }
    
}

extension EntryOptionsViewController: DisplayLoaderInterface {}
