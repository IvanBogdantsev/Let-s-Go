//
//  LoginView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 20.08.2023.
//

import UIKit

final class LoginView: UIView {
    
    let vStackView = UIStackView(axis: .vertical, spacing: 25)
    let emailTextField = UnderlinedTextField()
    let passwordTextField = UnderlinedTextField()
    let showPasswordButton = UIButton()
    let loginButton = UIButton()
    let forgotPasswordButton = UIButton()
    let loginLabel = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubviews(vStackView)
        vStackView.addArrangedSubviews(loginLabel, emailTextField, passwordTextField, forgotPasswordButton, loginButton)
        vStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(75)
            $0.center.equalToSuperview()
        }
        vStackView.setCustomSpacing(10, after: loginLabel)
    }
    
    private func setStyle() {
        backgroundColor = .letsgo_main_gray
        
        emailTextField.emailStyle()
        passwordTextField.securedEntryStyle()
        showPasswordButton.setImage(Images.eye_fill, for: .normal)
        passwordTextField.rightView = showPasswordButton
        
        loginLabel.text = Strings.login_into_account
        loginLabel.font = .letsgo_title3().bolded
        loginLabel.textColor = .letsgo_white
        
        forgotPasswordButton.framelessStyle()
        forgotPasswordButton.setTitle(Strings.forgot_password, for: .normal)
        
        loginButton.loginStyle()
    }
    
}
